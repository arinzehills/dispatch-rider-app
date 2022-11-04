import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dispacher_app/admin/admin_dashboard.dart';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/drivers/drivers_drawer.dart';
import 'package:dispacher_app/drivers/drivers_dashboard.dart';
import 'package:dispacher_app/drivers/drivers_notification.dart';
import 'package:dispacher_app/drivers/drivers_settings.dart';
import 'package:dispacher_app/drivers/drivers_orders.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  
  List<Widget> _widgetOptions = <Widget>[
    DriversDashboard(),
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
     final user= Provider.of<Users>(context);
    return StreamBuilder<Object>(
     stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Loading();
        }
        if(snapshot.hasData){
          UsersDetail userData= snapshot.data;
         String isDriver=userData.isDriver;
         String isAdmin=userData.role;
        if ((isDriver=='true') && (isAdmin!='admin')) {
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
        else if((isDriver=='false') && (isAdmin=='admin')) {
          return AdminDashboard();
        }
        else{
          return Authenticated();
        }
        }
        else {
                                   return Center(child: CircularProgressIndicator.adaptive());
                                 }
      }
    );
  }
}