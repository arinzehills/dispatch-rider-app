import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
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
             title: Text(userData.name+' Profile'),
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
                        backgroundImage: AssetImage('assets/avatar.png'),
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
                         Icon(
                          Icons.account_circle,
                          color: Color(MyApp().myred),
                        )
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
                        //for Phone
                 
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
