import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/components/constants.dart';
import 'package:dispacher_app/components/progress_button.dart';
import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dispacher_app/components/send_button.dart';
import 'package:dispacher_app/users/place_order.dart';

import 'orders.dart';

class PlaceOrderDetails extends StatefulWidget {
  String title;
  Stream stream;
  final String driversuid;
  final String phone;
  final String email;
  final String customersName;
  final String customersuid;
  final String customersPhone;
  final String driversName;
  final String message;
  final Function pressed;
  final Function trackDriver;
  final String placeHolder;
   String sendOrder;
 String pickup='';
  PlaceOrderDetails({

                  this.driversuid,this.driversName,
                  this.customersName, this.customersuid,this.customersPhone,
                  this.placeHolder,this.pressed,
                  this.message,this.sendOrder,
                  this.stream,this.title, contents, this.pickup,
                   this.phone, this.email,
                   this.trackDriver});

 

  @override
  _PlaceOrderDetailsState createState() => _PlaceOrderDetailsState();
}

class _PlaceOrderDetailsState extends State<PlaceOrderDetails> {
  
 final _formKey = GlobalKey<FormState>();

  String error;

  Widget contents(BuildContext context){
    return Column(

    );
  }

  driversOrders(uid,driverName,customersName,message,pickup,customersPhone,) async {
          return await  FirebaseFirestore.instance.collection('driverOrders')
                                        .doc(uid).collection('orders')
                                        .add({
                                        'Customeruid':widget.customersuid,
                                        'driversuid':uid,
                                        'driversName': driverName,
                                        'CustomersName' :customersName,
                                        'CustomersPhone':customersPhone,
                                        'message': message,
                                       'pickup location': pickup,
                                        'Date':DateTime.now().toString(),
                                        'TimeStamp':DateTime.now(),
                                        'Time':DateFormat.jm().format(DateTime.now()),
                                            });
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream:widget.stream,
      builder: (context, snapshot) {
        return Stack(
                                    children: <Widget>[
                                      Container(
                      padding: EdgeInsets.only(left:1,top:60, right:1,bottom:20),
                      margin: EdgeInsets.only(top: Constants.avatarRadius*3.4),
                      decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Constants.padding),
                      boxShadow: [
                          BoxShadow(color: Colors.black,offset: Offset(0,10),
                          blurRadius: 10
                          ),
                          ]
                    ),
                  child: Card(
                                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                        Text(widget.title,
                              style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                        SizedBox(height: 2,),
                        Padding(
                          padding: EdgeInsets.only(top:0, bottom:0),
                          child: Center(
                            child: Column(
                             
                              children: [
                                FlatButton.icon(
                                          onPressed: (){
                                           launch("tel:${widget.phone}");
                                          },
                                          icon: Icon(Icons.call, color: Color(MyApp().myred),size: 33,),
                                          
                                          label: Text(
                                            widget.phone ,
                                           maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 5
                                            ),
                                            ),
                                        ),
                                        SizedBox(height:4),
                                        // FlatButton.icon(
                                        //   onPressed: (){
                                        //    launch("mailto:${widget.email}");
                                        //   },
                                        //   icon: Icon(Icons.email, color: Color(MyApp().myred),size: 33,),
                                          
                                        //   label: Text(
                                        //     widget.email,
                                        //    maxLines: 1,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: TextStyle(
                                        //       color: Colors.black,
                                        //       letterSpacing: 5
                                        //     ),
                                        //     ),
                                        // ),
                                        
        
                              ],
                            ),
                          ),
                        ),
                        
                           Form(
                                       key: _formKey,
                                              child: Column(
                                            children: <Widget>[
                                                TextFormField(
                                                  validator: (val)=> val.isEmpty ? 'Enter pick up location' : null,
                                                decoration:textFieldDecoration.copyWith(
                                                prefixIcon: Icon(
                                                Icons.location_on,
                                                color: iconsColor,
                                                ),
                                                hintText: 'Enter pick up location',
                                                       ) ,
                                            onChanged: (val) => setState(() => widget.pickup= val),
                                    ),
                                    
                                    
                                      Text(
                                              error ?? '',
                                              style: TextStyle(color: Colors.red),
                                              ),    
                                            ]
                                          ), 
                                    ) ,
                            
                           MyProgressButton(
                              pressed:()async{
                                  if(_formKey.currentState.validate()){
                                        // add data to drivers orders collection
                                         driversOrders(widget.driversuid,widget.driversName,
                                         widget.customersName, widget.message,widget.pickup,
                                         widget.customersPhone);

                                         widget.pressed();// calls any other function passed to it
                                         
                                        
                                          // add data to  orders  Collection(For users)
                                          return await  FirebaseFirestore.instance.collection('orders')
                                                        .doc(widget.customersuid).collection('user_orders').add({
                                        
                                            'driversuid':widget.driversuid,
                                            'driversName': widget.driversName,
                                            'driverPhone': widget.phone,
                                            'Customeruid':widget.customersuid,
                                            'CustomersName' : widget.customersName,
                                            'CustomersPhone':widget.customersPhone,
                                            'pickup location': widget.pickup,
                                            'message':widget.message,
                                            'Date':DateTime.now().toString(),
                                            'TimeStamp':DateTime.now(),
                                            'Time':DateFormat.jm().format(DateTime.now()),
                                            })
                                            .then((_) {
                                            setState(() {
                                              widget.sendOrder='Orderplaced';
                                              
                                            });
                                               Navigator.of(context).push(
                                                     MaterialPageRoute(builder: (context) => Orders()),
                                                     );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Color(MyApp().myred),
                                                    content: Text(' Order Placed Successfully,')
                                                      )
                                                    );
                                            
                                          }).catchError((onError) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(content: Text(onError)));
                                          });
                                          
                                       }
                                  
                              },
                              placeHolder: widget.placeHolder ?? '',
                              )
                          ,
                           
                          MyProgressButton(
                              pressed: widget.trackDriver,
                              placeHolder: 'See Drivers Location',
                              ),
                                   
                    ],
                ),
                  ),
            ),
            Positioned(
                    left: Constants.padding,
                    right: Constants.padding,
                    top: 100,
                    child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: Constants.avatarRadius,
                    child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                      child: Image.asset("assets/delivery1.png")
                  ),
                ),
            ),
            contents(context)
          ],
        );
      }
    );
  }
}