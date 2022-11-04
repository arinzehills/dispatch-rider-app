import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/drawer.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/main.dart';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:dispacher_app/components/bottomNav.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class DriversDashboard extends StatefulWidget {
 
  @override
  _DriversDashboardState createState() => _DriversDashboardState();
}

class _DriversDashboardState extends State<DriversDashboard> {
   LocationData _currentPosition;
  String _address,_dateTime;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();
  var firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  GoogleMapController _controller;

 @override
  void initState() {
    // TODO: implement initState
     getLoc();
    super.initState();
   
    
  }

Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
      
    
        return StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance
            .collection('driverOrders')
            .doc(user.uid)
            .collection('orders')
            .snapshots(),
      builder: (context, snapshot) {
         if(snapshot.hasData){
            _addGeoPoint(user.uid);
           return Scaffold(
          // drawer: MyDrawer(),
          appBar:AppBar(
            title: Text('Dashboard'),
           backgroundColor: Color(MyApp().myred),
           centerTitle:true,
          ),
          body:Column(
            children:<Widget> [
                dashBoard(context,snapshot.data.size.toString()),
                //here you set where the driver will set his avalabilty
                // Row(
                //   children: [
                //       Padding(
                //         padding: const EdgeInsets.only(left:18.0),
                //         child: Text(
                //           'Set wether you are available or not ',
                //           style:TextStyle(
                //             color: Color(MyApp().myred),
                //           )
                //         ),
                //       )
                //   ],
                // ),
                //  Row(
                //         children: [
                //            Padding(
                //              padding: const EdgeInsets.only(left:8.0),
                //              child: StreamBuilder<Object>(
                //                stream: FirebaseFirestore.instance
                //                   .collection('users')
                //                   .doc(user.uid)
                //                   .snapshots(),
                //                builder: (context, snapshot) {
                //                  return FlatButton.icon(
                //                               onPressed: (){
                //                                 Navigator.of(context).push(
                //                       MaterialPageRoute(builder: (context) => DriversDashboard()));
                //                               },
                //                               icon: Icon(
                //                                 Icons.toggle_on, 
                //                                 size: 30,
                //                                 color: Colors.green,), 
                //                               label: Text(
                //                                 'Available',
                //                                maxLines: 1,
                //                                 overflow: TextOverflow.ellipsis,
                //                                 style: TextStyle(
                //                                   color: Colors.green,
                //                                   fontSize: 15
                //                                 ),
                //                                 ),
                //                             );
                //                }
                //              ),
                //            ),
                         
                //         ],
                //       ),
                Spacer(),
                
                        ]
                      ) 
                    );
         }
        else{
             return Loading();
            }
      }
    );
              }
            //dashboard card
             Widget dashBoard(BuildContext context,var orders){
            return   SizedBox(
              
          height: 251,
          child: Card(
            
          color:Colors.deepOrangeAccent,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.only(bottom :30.0, left:8,),
              child: Column(
                
                children: [
                    Row(
                      children: [
                            Text(
                              'Hi',
                              style: TextStyle(
                              fontSize: 32.0,
                                  color: Color(int.parse("0xff54a2d6")),
                                fontWeight: FontWeight.bold, 
                                ),
                            ),
                            Text(
                              ' Driver' + '!',
                              style: TextStyle(
                              fontSize: 32.0,
                                  color: Color(int.parse("0xff54a2d6")),
                                fontWeight: FontWeight.bold, 
                                                ),  
                                 )
                               ],
                        ),
               Row(
                      children: [
                            Row(
                              children:<Widget> [
                                Icon(
                                  Icons.assignment_turned_in,
                                  color: Colors.white,
                                ),
                                Text(
                                'Orders ',
                                  style: TextStyle(
                                      color: Colors.white, 
                                    fontSize: 15
                                    ),
                                ),
                                
                              ],
                            ),
                            Spacer(),
                            
                          //   FlatButton.icon(
                          //         onPressed: (){
                          //           Navigator.of(context).push(
                          // MaterialPageRoute(builder: (context) => DriversDashboard()));
                          //         },
                          //         icon: Icon(Icons.pending_actions, color: Colors.white,), 
                          //         label: Text(
                          //           'Pending Orders',
                          //          maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 15
                          //           ),
                          //           ),
                          //       )
                             
                            
                      ],
                    ),
                    
                    Row(
                      children:[
                        Text(
                          orders,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100
                            ), 
                         ),
                         Spacer(),
                         Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100
                          ), 
                             
                        )
                      ],
                    ),
                     
                  ],
                  
                ),
              ),
            ),
            
          );
  }
  Future<void> _addGeoPoint(uid) async {
     await Firebase.initializeApp();
  var pos = await location.getLocation();
  GeoFirePoint point;
  point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
  
  return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('location')
        .doc(uid)
        .set({ 
            'avalable': 'available',
            'position': point.data,
            
            });
}
getLoc() async{
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
    
    location.onLocationChanged.listen((LocationData currentLocation) {
      
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
       

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(_currentPosition.latitude, _currentPosition.longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }
  Future<List<geocoder.Address>> _getAddress(double lat, double lang) async {
    final coordinates = new geocoder.Coordinates(lat, lang);
    List<geocoder.Address> add =
    await geocoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
          }

    
}

