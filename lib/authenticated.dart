import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dispacher_app/admin/admin_dashboard.dart';
import 'package:dispacher_app/components/bottomNav.dart';
import 'package:dispacher_app/drivers/drivers_location.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/users/place_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'drawer.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:dispacher_app/main.dart';
import 'components/loading.dart';
import 'components/progress_button.dart';
import 'services/database.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';


class Authenticated extends StatefulWidget {
    
  @override
  _AuthenticatedState createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
      
      String _currentAddress;
      UserCredential user;
      bool loading=false;

  ConnectivityResult previous;
  StreamSubscription _streamSubscription;
  bool showdialog=false;
    Future<bool> checkInternet() async {
        try{
          final result =await InternetAddress.lookup('google.com');
      
        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
          //connection is available
          // // Navigator.of(context).pop(false);
          // setState(() {
          //   showdialog=false;
          // });
          return Future.value(true);
        }
       
    } on SocketException catch(_){
      // no internet
      // _showDialog();
           return 
          Future.value(false);
         }
    }
      @override
  void initState() {
    // TODO: implement initState
     
    super.initState();
        Connectivity().onConnectivityChanged.
                    listen((ConnectivityResult connresult) {
           if(connresult == ConnectivityResult.none){
                        // no internet
                        showdialog=true;
                         showDialog(
                            context: context,
                          barrierDismissible: false, // user must tap button!
                           builder:(context)=>AlertDialog(
                              title:Text('No internet Connection available'),
                              actions: <Widget>[
                                      RaisedButton(
                                  child: Text('Exit'),
                                  color: Color(MyApp().myred),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                  onPressed:()=>SystemChannels.
                                            platform.invokeMethod('SystemNavigator.pop'),
                                ),
                              ]
                            ),
                         
                         );
          }else if (previous ==ConnectivityResult.none){
            checkInternet().then((result){
              if(result ==true){
                //there is internet connection
                if(showdialog==true){
                  showdialog= false;
                  Navigator.pop(context);
                }
              }
            });
          }
               
               previous = connresult;
             });

    
  }
      Future <bool> _onBackPressed(){
    
    return showDialog(
      context: context,
      builder:(context)=>AlertDialog(
        title:Text('Do You want to Exit'),
        actions: <Widget>[
          RaisedButton(
            child: Text('no'),
            color: Color(MyApp().myred),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed:()=> Navigator.pop(context,false),
          ),
          RaisedButton(
            child: Text('Yes'),
            color: Color(MyApp().myred),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed:()=> Navigator.pop(context,true),
          ),
        ]
      ),
    );
     
  }
   @override
  void dispose(){
    super.dispose();
    _streamSubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
     _addGeoPoint(user.uid);
    return  StreamBuilder<UsersDetail>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
       
         if (snapshot.connectionState == ConnectionState.waiting) {
          return  Loading();
        }
        if(snapshot.hasData){
          UsersDetail userData= snapshot.data;
         String isDriver=userData.isDriver;
         String isAdmin=userData.role;
        if ((isDriver=='false') && (isAdmin!='admin')) {
          return WillPopScope(
             onWillPop: ()=>_onBackPressed(),
                child: loading ? Loading():  Scaffold(
               drawer: MyDrawer(name: userData.name,phone: userData.phone,),
               appBar:AppBar(
                 title: Text('Dispatcher Rider'),
               backgroundColor: Color(int.parse("0xffe37029")),
               centerTitle:true,
                          ),
                          
                          body:Column(
                            children:<Widget> [
                              
                              MyCard(username:' ' + userData.name,
                                          
                                        pressed: (){
                                              setState(() {
                                                loading=true;
                                              });
                                              Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => DriversLocation()));
                                        }
                                          ),
                              
                              
                              // FlatButton(
                              // child: Text("Get location"),
                              // onPressed: () {
                              //       _getCurrentLocation();
                              //     },
                              //     textColor: Color(MyApp().myred),
                              //     ),
                             
                            Spacer(),
                              MyProgressButton(placeHolder: 'Deliver Package',pressed: (){
                                 
                    //               Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => TestFile()));
                          
                                   showDialog(context: context,
                                    builder: (BuildContext context){
                                     return WillPopScope(
                                          onWillPop: () async{
                                            return Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(builder: (context) =>
                                              Authenticated()),
                                               (Route<dynamic> route) => false);
                                          },
                                          child: Center(
                                            child: PlaceOrder(
                                                title: "PLACE ORDER",
                                                )
                                              ),
                                     );
                                          }
                                          );
                                      }),
                                ],
                            ),
                       ),
          );
        } else if((isDriver=='false') && (isAdmin=='admin')) {
          return AdminDashboard();
        }
        else{
          return BottomNav();
        }
        } else{
            return Loading();
        }
        
      }
      
    );
             }

    Location location = Location();

             Geoflutterfire geo = Geoflutterfire();
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
     
  
  
   
  

  

}



  class MyCard extends StatefulWidget {
    
     final String username;
      String devicelocation ='';
      Function pressed;
      //contructor
      MyCard({this.username ,this.devicelocation,this.pressed});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
   LocationData _currentPosition;
  String _address,_dateTime;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();

@override
  void initState() {
    // TODO: implement initState
     getLoc();
    super.initState();
   
    
  }

    Future<List<geocoder.Address>> _getAddress(double lat, double lang) async {
    final coordinates = new geocoder.Coordinates(lat, lang);
    List<geocoder.Address> add =
    await geocoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
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

      @override
      Widget build(BuildContext context) {
        getLoc();
        return SingleChildScrollView(
            child: SizedBox(
          height: 250,
          child: Card(
          color:Colors.deepOrangeAccent,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                
                children: [
                    Row(
                      children: [
                            Text(
                              'Hi',
                              style: TextStyle(
                              fontSize: 32.0,
                                  color: Colors.white,
                                fontWeight: FontWeight.bold, 
                                ),
                            ),
                            SizedBox(
                              width: 230,
                              child: Wrap(
                                       children: [
                                           Text(
                                    widget.username + '!',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                    fontSize: 32.0,
                                        color: Colors.blue[200],
                                      fontWeight: FontWeight.bold, 
                                    ),  
                            ),
                          ],
                              ),
                            )
                      ],
              ),
              Text(
                            'Welcome Back! Search for a rider closest to you in minutes',
                              style: TextStyle(
                              fontSize: 12.0,
                                  color: Colors.white,
                                fontWeight: FontWeight.bold, 
                              ),  
                          ),
                          Spacer(),
                        Row(
                      children: [
                            Row(
                              children:<Widget> [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 190,
                                  child: Wrap(
                                      children: [
                                      Text(
                                          _address!=null ?
                                          "Address: $_address" : 'Address unavailable',
                                       overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12 ,
                                         
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                            Spacer(flex: 1, ),
                            Row(
                              children: [
                             Icon(
                                  Icons.lock_clock,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Wrap(
                                      children: [
                                         
                                      Text(
                                     
                                           ' '+ DateFormat.jm().format(DateTime.now()),
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12 ,
                                         
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                              ],
                            )
                      ],
                    ),
                    
                  ],
                  
                ),
              ),
            ),
          ),
        );
      }
}
      
