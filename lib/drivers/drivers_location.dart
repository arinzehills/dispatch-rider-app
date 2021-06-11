import 'dart:async';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:dispacher_app/components/my_button.dart';
import 'package:intl/intl.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io' show Platform;

class DriversLocation extends StatefulWidget {
Function addGeoPoint;
final String uid;
final String driversName;
    DriversLocation({
      this.uid,
      this.driversName,
      this.addGeoPoint,
    });
  @override
  _DriversLocationState createState() => _DriversLocationState();
}

class _DriversLocationState extends State<DriversLocation> {
         LocationData _currentPosition;
  String _address,_dateTime;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();
  var firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  GoogleMapController _controller;
   Completer<GoogleMapController> _controllerGoogleMap=Completer();
  LatLng _initialcameraposition;

  BehaviorSubject<double> radius = BehaviorSubject();
  Stream<dynamic> query;
  StreamSubscription subscription;
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  bool loading=false;

   void _updateMarkers(List<DocumentSnapshot> documentList) {
     
    print(documentList);
    documentList.forEach((DocumentSnapshot document) {
        GeoPoint pos = document.data();
        var  point = geo.point(latitude:_currentPosition.latitude,longitude: _currentPosition.longitude);
        double distance = point.distance(lat:_currentPosition.latitude,lng: _currentPosition.longitude);
        
        var marker = Marker(
          markerId: MarkerId('home'),
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          // infoWindowText: InfoWindowText('Magic Markerm', '$distance kilometers from query center')
        );


    });
  }
   


      _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;


    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center, 
        radius: rad, 
        field: 'position', 
        strictMode: true
      );
    }).listen(_updateMarkers);
  }

  _updateQuery(value) {
      setState(() {
        radius.add(value);
      });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialcameraposition = LatLng(0.5937, 0.9629);

  }

 
  Future <bool> _onBackPressed(){
    
    return   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
   Authenticated()), (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
      final user= Provider.of<Users>(context);
    return loading ? Loading(): WillPopScope(
             onWillPop: ()=>_onBackPressed(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users')
            .doc(widget.uid)
            .collection('location')
            .doc(widget.uid)
            .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
               DocumentSnapshot  locationData=snapshot.data;
                    dynamic orderData=locationData.data();
              GeoPoint geopoint=orderData['position']['geopoint'];
              getLoc(geopoint.latitude, geopoint.longitude);
            Future<void> _onMapCreated(GoogleMapController _cntlr,)
                    async {
                        _controllerGoogleMap.complete(_cntlr);
                      _controller =await _controllerGoogleMap.future;
                      location.onLocationChanged.listen((geopoint) {
                        GeoPoint geopoint=orderData['position']['geopoint'];
                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(geopoint.latitude, geopoint.longitude),
                              zoom: 15),
                          ),  
                        );
                      });
                    }
            return Container(
             
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 434,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _initialcameraposition,
                            zoom: 15),
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                          ),
                          
                        ),
                            Text(widget.driversName),
                        SizedBox(
                          height: 3,
                        ),
                        if (_dateTime != null)
                          Text(
                            "Date/Time: $_dateTime",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.orange,
                              ),
                          ),

                        SizedBox(
                          height: 3,
                        ),
                        if (_currentPosition != null)
                          Text(
                            "Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        SizedBox(
                          height: 3,
                        ),
                        if (_address != null)
                          Text(
                            "Address: $_address",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.deepOrange
                            ),
                          ),
                        SizedBox(
                          height: 3,
                        ),
                        //to track driver
                        SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top:0.0,),
                                                    child: MyButton(
                            placeHolder: widget.driversName ?? 'Drivers Name',
                            pressed: (){
                              // _addGeoPoint(user.uid);
                              // _onMapCreated(_controller);
                              GeoPoint geopoint=orderData['position']['geopoint'];
                              print(geopoint.latitude);
                            },
                          ),
                                                  ),
                        ),
                        Spacer(),
                        Text(
                          'Developed By motiv8 Technologies',
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          }
        ),

      ),
    );
  }


  getLoc(latitude,longitude) async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(latitude,longitude);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(latitude, longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }

Future<void> _addGeoPoint(id) async {
     await Firebase.initializeApp();
  var pos = await location.getLocation();
  GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
  var collectionReference = firestore.collection('locations');
var geoRef = geo.collection(collectionRef: collectionReference);
 var longitude=pos.longitude;
  return
    geoRef.setPoint(id,  'Position',pos.latitude,longitude);
  
  //  firestore.collection('location')
  // .doc('user.id')
  //       .update({ 
  //   'avalable': 'available',
  //   'position': point.data,
     
  // });
}
  Future<List<geocoder.Address>> _getAddress(double lat, double lang) async {
    final coordinates = new geocoder.Coordinates(lat, lang);
    List<geocoder.Address> add =
    await geocoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
          }

    }

