import 'dart:convert';
import 'package:dispacher_app/drivers/drivers_location.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:dispacher_app/users/placeorder_detail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}
  class DriverProvider extends ChangeNotifier{
    final Stream<QuerySnapshot> stream=FirebaseFirestore.instance
    .collection('users')
    .where('driver', isEqualTo: 'true').snapshots();
    
  }
   
class PlaceOrder extends StatefulWidget {
  
  String title;
  Image image;
   PlaceOrder({
     this.image,this.title
   });
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  String sendOrder='Send Order';
  String pickup='';
    @override
    void initState(){
      super.initState();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'mipmap/ic_launcher',
              ),
            ));
      }
      });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('A new onMessageOpenApp was');
          RemoteNotification notification=message.notification;
          AndroidNotification android= message.notification?.android;
            if(notification != null && android!=null){
              showDialog(context: context, builder: (_){
                return Stack(
                     children: [
                    AlertDialog(
                      title: Text(notification.title),
                      content: SingleChildScrollView(
                        child: Column(
                           children: [
                             Text(notification.body)
                           ],
                        ),
                      ),
                    ),
                  ],
                );
              });
            }
         });
    }
    void sendNotification(){
      flutterLocalNotificationsPlugin.show(
        0,
         'Order','You send an order',
         NotificationDetails(
           android:AndroidNotificationDetails(
             channel.id,
             channel.name,
             channel.description,
             importance: Importance.high,
             color: Colors.blue,
             playSound: true,
             icon: '@mipmap/ic_launcher',
           )
         )
         );
    }
    Widget _buildList(){
      // final List<String> drivers = <String>['A', 'B', 'C','A', 'B', 'C','A', 'B', 'C'];
      final Stream<QuerySnapshot> stream=FirebaseFirestore.instance
                                  .collection('users')
                                  .where('isDriver', isEqualTo: 'true').snapshots();  
      final user= Provider.of<Users>(context);
   
    //send order to data base to a driver
    
    
      return 
      StreamBuilder<QuerySnapshot>(
        stream:  stream,
        builder: (context,snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
                 child: CircularProgressIndicator()
          );
        }
            if(snapshot.hasData){
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(0,1,8,1),
              itemCount: snapshot.data.size, //documents.length,
              itemBuilder: (BuildContext context, int index) {
                //    snapshot.data.docs.map((DocumentSnapshot document) {
              //  dynamic  data= document.data();
                  DocumentSnapshot  document=snapshot.data.docs[index];
                  dynamic data=document.data();
              return Card(
                  child:ListTile(
                          title: Text(data['userName'],
                                    style: TextStyle(
                                      color: Color(MyApp().myred,),
                                      fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          subtitle: Padding(
                            padding: EdgeInsets.all(3.0),
                            // child: Row(
                            //       children: [
                            //                 Icon(
                            //                        Icons.location_on,
                            //                       color: Colors.green,
                            //                       size: 13,
                            //                     ),
                            //               SizedBox(
                            //                 width: 50,
                            //                 child: Wrap(
                            //                   children: [
                                                
                            //                 // Text(
                            //                 //   'Bosso dfdsadsadfdhgjhfhfjhfjh',
                            //                 //   maxLines: 1,
                            //                 //   overflow: TextOverflow.ellipsis,
                            //                 //     style: TextStyle(
                            //                 //         color: Colors.black, 
                            //                 //         fontSize:10
                            //                 //       ),
                            //                 // ),
                            //                  ],
                            //                 ),
                            //               ),
                            //               Spacer(),
                            //                Text(
                            //               'Available',
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontSize:10
                            //                   ),
                            //               ),
                            //               Icon(
                            //                 Icons.toggle_on,
                            //                 color: Colors.green,
                            //               ),
                            //         ],
                            //      ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(-7,5,3, 5),
                          leading:  CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: Constants.avatarRadius,
                          child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                          child: Image.asset("assets/avatar.png")
                                        ),
                                     ),
                          onTap:() => {
                            
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  // final driver=Provider.of<QuerySnapshot>(context);
                                   
                             return StreamBuilder<UsersDetail>(
                               stream:  DataBaseService(uid: user.uid).userData,
                               builder: (context, snapshot) {
                                 if(snapshot.hasData){
                                   
                                   UsersDetail userData= snapshot.data;
                                   String message =userData.name + 'sent you an order';
                               final CollectionReference ordersCollection=
                                FirebaseFirestore.instance.collection('orders');
                                    
                                  var colorofOrderButton=Color;
                                 return PlaceOrderDetails(
                                   driversuid: data['uid'],
                                   title: data['userName'],
                                   driversName: data['userName'],
                                    phone: data['phone'],
                                    email: data['email'],
                                    message: message,
                                    customersName:userData.name ,
                                    customersuid: userData.uid,
                                    customersPhone: userData.phone,
                                    sendOrder: sendOrder,
                                    pressed: () async{
                                      sendNotification();
                                    },
                                    trackDriver: ()async{
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => 
                                            DriversLocation(uid: data['uid'],driversName:data['userName'])));
                                    },

                                        placeHolder: sendOrder,
                                     );
                                 }else {
                                   return Center(child: CircularProgressIndicator.adaptive());
                                 }
                               }
                             );
                                 }        
                              ),
                          }),
                        );
                  },
            separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,),
                );
             } 
             else{
               Center(
                 child: CircularProgressIndicator(),
               );
             }
           }
         );
      }
        
    
    //used for place order class
      contentBox(context, list){
      return Stack(
         children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
            , right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 50
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,
                  color:Colors.deepOrangeAccent,wordSpacing: 3),
                ),
                Text(
                'Riders Closest to you',
                style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),
                ),
              SizedBox(height: 4,),
              Divider(),Spacer(
               
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:1,top: 95
            , right: 1,bottom: 1
          ),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            
         child: list
        ),
        Positioned(
          left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/dispatch_app_icon.png")
              ),
            ),
        ),
      ],
      );
    }
    
  @override
  Widget build(BuildContext context) {
    return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
           ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context,_buildList()),          
      );
  }
}
  