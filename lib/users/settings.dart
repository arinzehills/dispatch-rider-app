import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_user_detail.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _currentName;
  String _currentPhone;
  String _currentEmail;
  String _currentAddress;
  int id;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);

    return StreamBuilder<UsersDetail>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UsersDetail userData= snapshot.data;
        return Scaffold(
           appBar: AppBar(
             title: Text('Settings'),
                  ),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Wrap(
                          children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/2.JPG'),
                        radius: 40.0,
                      ),
                    ),
                    Divider(
                      height: 20.0,
                    ),
                    //for user name
                    Row(
                      children: [
                       SizedBox(
                          width: 240,
                          child: Wrap(
                            children: [
                              Text(
                                 userData.name,
                                maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                style:TextStyle(
                                  color:Color(MyApp().myred),
                                  fontSize: 25.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                      icon: Icon(Icons.edit),
                      color: Color(MyApp().myred),
                       onPressed: (){
                        showDialog(context: context,
                                builder: (BuildContext context){
                             return EditDetails(
                               id: 1,
                               title: 'Edit Username',
                               hintText: userData.name,
                                dataNameToUpdate: _currentName,
                               );
                          });
                       }
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 2,),
                    Text(
                      'user name',
                      style:TextStyle(
                        color:Color(MyApp().myblue),
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height:10),
                    //for Phone Number
                     SizedBox(height:10),
                    Row(
                     children: [
                       SizedBox(
                          width: 240,
                                  child: Wrap(
                                    children: [
                              Text(
                                userData.phone,
                                  maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                style:TextStyle(
                                  color:Color(MyApp().myred),
                                  fontSize: 25.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                         ),
                       ),
                        //for editing address
                          IconButton(
                      icon: Icon(Icons.edit),
                      color: Color(MyApp().myred),
                       onPressed: (){
                        showDialog(context: context,
                                builder: (BuildContext context){
                             return EditDetails(
                               
                               title: 'Edit Phone',
                               hintText: userData.phone,
                               dataNameToUpdate: _currentPhone,
                               );
                          });
                       }
                        ),
                        Spacer(),
                         Icon(
                          Icons.phone,
                          color: Color(MyApp().myred),
                        )
                     ],
                   ),
                    SizedBox(height: 5,),
                    Text(
                      'Phone Number',
                      style:TextStyle(
                        color:Color(MyApp().myblue),
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //for email
                   Row(
                     children: [
                      SizedBox(
                          width: 240,
                          child: Wrap(
                            children: [
                              Text(
                                userData.email,
                                  maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                style:TextStyle(
                                  color:Color(MyApp().myred),
                                  fontSize: 25.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                         ),
                       ),
                        Spacer(),
                           IconButton(
                      icon: Icon(Icons.edit),
                      color: Color(MyApp().myred),
                       onPressed: (){
                        showDialog(context: context,
                                builder: (BuildContext context){
                             return EditDetails(
                               id: 3,
                               title: 'Edit Details',
                               hintText: userData.email,
                               dataNameToUpdate: _currentEmail,
                               );
                          });
                       }
                        ),
                        Icon(
                          Icons.email,
                          color: Color(MyApp().myred),
                        ),
                        
                     ],
                   ),
                    SizedBox(height: 5,),
                    Text(
                      'email address',
                      style:TextStyle(
                        color:Color(MyApp().myblue),
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height:10),
                    //for Address
                    Row(
                     children: [
                       SizedBox(
                          width: 240,
                                  child: Wrap(
                                    children: [
                              Text(
                                userData.address,  maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                style:TextStyle(
                                  color:Color(MyApp().myred),
                                  fontSize: 25.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                         ),
                       ),
                        //for editing address
                          IconButton(
                      icon: Icon(Icons.edit),
                      color: Color(MyApp().myred),
                       onPressed: (){
                        showDialog(context: context,
                                builder: (BuildContext context){
                             return EditDetails(
                               
                               id: 4,
                               title: 'Edit Address',
                               hintText: userData.address,
                               dataNameToUpdate: _currentAddress,
                               );
                          });
                       }
                        ),
                        Spacer(),
                         Icon(
                          Icons.location_city,
                          color: Color(MyApp().myred),
                        )
                     ],
                   ),
                    SizedBox(height: 5,),
                    Text(
                      'Home Address',
                      style:TextStyle(
                        color:Color(MyApp().myblue),
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height:10),
                   Row(
                     children: [
                       //change password
                       Text(
                          'Change Password',
                          style:TextStyle(
                            color:Color(MyApp().myred),
                            fontSize: 25.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                         Icon(
                          Icons.edit,
                          color: Color(MyApp().myred),
                        )
                     ],
                   ),
                    SizedBox(height: 5,),
                    // Text(
                    //   'info@website.com',
                    //   style:TextStyle(
                    //     color:Color(MyApp().myblue),
                    //     fontSize: 15.0,
                    //     letterSpacing: 2.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    
                  ],
                ),
              ],
            ),
          )
        );
       }
       else{
         return Loading();
       }
      }
    );
  }
}