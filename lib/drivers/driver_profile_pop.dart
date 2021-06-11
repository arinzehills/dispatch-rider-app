import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/components/progress_button.dart';
import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dispacher_app/components/send_button.dart';
import 'package:dispacher_app/users/place_order.dart';

class DriverDetails extends StatefulWidget {
  String title;
  Stream stream;
  final String id;
  final String phone;
  final String email;
  final Function pressed;
  final Function trackDriver;
  final String placeHolder;
  DriverDetails({
                  this.id,
                  this.placeHolder,this.pressed,
                  this.stream,this.title, contents,
                   this.phone, this.email,
                   this.trackDriver});

  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  

  Widget contents(BuildContext context){
    return Column(

    );
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
                      margin: EdgeInsets.only(top: Constants.avatarRadius*5),
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
                                      FlatButton.icon(
                                        onPressed: (){
                                         launch("mailto:${widget.email}");
                                        },
                                        icon: Icon(Icons.email, color: Color(MyApp().myred),size: 33,),
                                        
                                        label: Text(
                                          widget.email,
                                         maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 5
                                          ),
                                          ),
                                      ),
        
                            ],
                          ),
                        ),
                      ),
                      
                          
                         MyProgressButton(
                            pressed: widget.pressed,
                            placeHolder: widget.placeHolder,
                            )
                        ,
                         
                        MyProgressButton(
                            pressed: widget.trackDriver,
                            placeHolder: 'See Drivers Location',
                            )
                        
                  ],
                ),
            ),
            Positioned(
                    left: Constants.padding,
                    right: Constants.padding,
                    top: 190,
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