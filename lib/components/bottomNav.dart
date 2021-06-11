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