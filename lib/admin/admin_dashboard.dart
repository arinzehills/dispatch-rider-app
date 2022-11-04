import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dispacher_app/admin/admin_home.dart';
import 'package:dispacher_app/drawer.dart';
import 'package:dispacher_app/drivers/drivers_notification.dart';
import 'package:dispacher_app/drivers/drivers_orders.dart';
import 'package:dispacher_app/drivers/drivers_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  
  List<Widget> _widgetOptions = <Widget>[
    AdminHome(),
    DriversOrders(),
    DriversNotification(),
    DriversSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         drawer: MyDrawer(),
        bottomNavigationBar:BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(MyApp().myred),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        
      ),
       body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}