import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/admin/admin_dashboard.dart';
import 'package:dispacher_app/auth_page.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'authenticated.dart';
import 'components/loading.dart';
import 'models/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class Wrapper extends StatefulWidget {
  
  
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
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
  void initState(){
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

  void _showDialog(){
    // setState(() {
    //   showdialog=true;
    // });
    // showdialog=true;
    // if(coo){
    //   showDialog(
    //   context: context,
    //   builder:(context)=>AlertDialog(
    //     title:Text('No internet Connection available'),
    //     actions: <Widget>[
    //              RaisedButton(
    //         child: Text('Exit'),
    //         color: Color(MyApp().myred),
    //          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    //         onPressed:()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    //       ),
    //     ]
    //   ),
    // );
    // }
    // else if (previous ==ConnectivityResult.none){
    //   checkInternet().then((value){
    //     if(result ==true){
    //        if(showdialog==true){
    //          showdialog= false;
    //          Navigator.pop(context);
    //        }
    //     }
    //   })
    // }
  }
  void checkConnectivity(){
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
  void dispose(){
    super.dispose();
    _streamSubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
     final user= Provider.of<Users>(context);
    
     if(user==null){
       return AuthPage();
     } 
     else{
        return StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData && snapshot.data != null){
              UserHelper.saveUser(snapshot.data);
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users')
                .doc(snapshot.data.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>
                  snapshots){
                     if(snapshot.hasData && snapshot.data != null){
                       final dynamic user = snapshots.data.data();
                       if(user['role']=='admin'){
                         return AdminDashboard();
                       }
                       else{
                         return Authenticated();
                       }
                     }
                     else{
                       return  Loading();
                      
                     }
                     
                      },
                  
              );
            } else{
              return Loading();
            }
            
          }
        );
     
      //  return StreamBuilder<Object>(
      //    stream: DataBaseService(uid: user.uid).userData,
      //    builder: (context, snapshot) {
      //      if(snapshot.hasData){
      //     UsersDetail userData= snapshot.data;
      //       if(userData.isDriver==true){
              
      //         return Authenticated();
      //       }
      //       else{
      //         return BottomNav();
      //      }
      //      }
      //    }
      //  );
     }
  }
}

