import 'package:dispacher_app/drivers/drivers_login.dart';
import 'package:dispacher_app/drivers/drivers_orders.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:dispacher_app/drivers/testfile.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/users/settings.dart';
import 'package:dispacher_app/users/profile.dart';
import 'package:dispacher_app/users/orders.dart';
import 'package:dispacher_app/components/loading.dart';

class MyDrawer extends StatelessWidget {
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.cancel),
                  color: Colors.white,
                   onPressed: (){
                     Navigator.of(context).pop();
                   }
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Arinze Hills',
                    style: TextStyle(color: Colors.white, fontSize: 25,),
                  ),
                ),
              ],
            ),
            
            decoration: BoxDecoration(
                color: Color(int.parse("0xff54a2d6")),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/delivery1.png'))
                    ),
             ),
          ListTile(
            leading: Icon(Icons.input,color: Colors.blue,),
            title: Text('Welcome'),
            onTap: () => {  Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.verified_user,color: Colors.blue,),
            title: Text('Profile'),
            onTap: () => {
                     Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => Profile()),
                    )},
          ),
          ListTile(
            leading: Icon(Icons.settings,color: Colors.blue,),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => Settings()),
                    )},
          ),
          ListTile(
            leading: Icon(Icons.border_color,color: Colors.blue,),
            title: Text('Orders'),
            onTap: () => {
                    Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => DriversOrders()),
                    )},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.blue,),
            title: Text('Logout'),
            onTap: () async{
                await _auth.signOut();
                 Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) =>DriversLogin()),
                    );
            },
          ),       
        ]
      ),
    );
  }
}