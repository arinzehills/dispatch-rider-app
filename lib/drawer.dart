import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'package:dispacher_app/users/settings.dart';
import 'package:dispacher_app/users/profile.dart';
import 'package:dispacher_app/users/orders.dart';
import 'components/loading.dart';
import 'models/user.dart';
import 'models/usersDetail.dart';

class MyDrawer extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String phone;
  
  final AuthService _auth=AuthService();

   MyDrawer({Key key, this.uid, this.name, this.email,this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
     var myred=Color(MyApp().myred);
        
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: [
                    Row(
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
                          child: SizedBox(
                            width: 190,
                            child: Wrap(
                                     children: [
                                Text(
                                 name ?? '',
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontSize: 25,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         SizedBox(
                            width: 190,
                            child: Wrap(
                                     children: [
                                 SizedBox(
                            width: 190,
                            child: Wrap(
                                     children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:30.0),
                                  child: Text(
                                   phone ?? '',
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white, fontSize: 15,),
                                    ),
                                ),
                                 
                              ],
                            ),
                          ),
                         
                          
                              ],
                            ),
                          ),
                       ],
                     ),
                  ],
                ),
                
                decoration: BoxDecoration(
                    color: myred,
                    
                        ),
                 ),
              ListTile(
                leading: Icon(Icons.input,color:myred,),
                title: Text('Welcome'),
                onTap: () => {  Navigator.of(context).pop()},
              ),
              ListTile(
                leading: Icon(Icons.verified_user,color:myred,),
                title: Text('Profile'),
                onTap: () => {
                         Navigator.of(context).push(
                         MaterialPageRoute(builder: (context) => Profile()),
                        )},
              ),
              ListTile(
                leading: Icon(Icons.settings,color: myred,),
                title: Text('Settings'),
                onTap: () => {Navigator.of(context).push(
                         MaterialPageRoute(builder: (context) => Settings()),
                        )},
              ),
              ListTile(
                leading: Icon(Icons.border_color,color: myred,),
                title: Text('Orders'),
                onTap: () => {
                        Navigator.of(context).push(
                         MaterialPageRoute(builder: (context) => Orders()),
                        )},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: myred,),
                title: Text('Logout'),
                onTap: () async{
                    //  Center(
                    //   child: CircularProgressIndicator.adaptive());
                     Navigator.of(context).push(
                         MaterialPageRoute(builder: (context) => Login()),
                        );
                        await _auth.signOut() ;
                },
              ),       
            ]
          ),
        );
       }
      
      
    
  
}