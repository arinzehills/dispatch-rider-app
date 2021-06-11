import 'package:dispacher_app/admin/admin_home.dart';
import 'package:dispacher_app/admin/admin_settings.dart';
import 'package:dispacher_app/drawer.dart';
import 'package:dispacher_app/drivers/drivers_notification.dart';
import 'package:dispacher_app/drivers/drivers_orders.dart';
import 'package:dispacher_app/drivers/drivers_settings.dart';
import 'package:flutter/material.dart';

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