import 'package:dispacher_app/components/constants.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/components/my_button.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dispacher_app/components/send_button.dart';
import 'package:dispacher_app/users/place_order.dart';

class EditDetails extends StatefulWidget {
  
   String  dataNameToUpdate;
  String title;
  final String hintText;
  final int id;
   Function pressed;
  EditDetails({this.title,this.hintText, contents,this.dataNameToUpdate,this.id,this.pressed});

  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final _formKey = GlobalKey<FormState>();

   String error='';

  Widget contents(BuildContext context){
    return Column(

    );
  }

  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
    return 
                                
                 StreamBuilder<UsersDetail>(
                   stream: DataBaseService(uid: user.uid).userData,
                   builder: (context, snapshot) {
                     if(snapshot.hasData){
                      UsersDetail userData= snapshot.data;
                      String validatePhone(val){
                        if(widget.hintText==userData.phone){
                          if(val.length <11 ){
                            return ' Phone number must not be less than 11 characters';
                          }
                          else if(val.isEmpty){
                            return 'required';
                          }
                          else{
                            return null;
                          }
                        }
                        else if(val.isEmpty){
                          return 'required';
                        }
                      }
                     return Container(
                      padding: EdgeInsets.only(left:1,top:10, right:1,bottom:20),
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
              child: Card(
                                  child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                        Text(
                          widget.title,
                         style: TextStyle(fontSize: 22,
                                color: Colors.black),
                         ),
                        SizedBox(height: 22,),
                     
                                            Form(
                                              autovalidateMode: AutovalidateMode.always,
                                     key: _formKey,
                                            child: Column(
                                          children: <Widget>[
                                              TextFormField(
                                                validator: validatePhone,
                                              decoration:textFieldDecoration.copyWith(
                                              prefixIcon: Icon(
                                              Icons.person,
                                              color: iconsColor,
                                              ),
                                              hintText: widget.hintText,
                                                     ) ,
                                          onChanged: (val) => setState(() => widget.dataNameToUpdate = val),
                                  ),
                                  
                                  
                                    Text(
                                            error,
                                            style: TextStyle(color: Colors.red),
                                            ),                  
                                       ],
                                     ),
                                   ),
                      
                        
                        
                       
                         MyButton(
                              pressed: () async{
                                if(_formKey.currentState.validate()){
                                 if(widget.hintText==userData.name){
                                    //if name is what will be edited, is passed as the hint text and 
                                    //the hint is equal to the name in the dataBase
                                      await DataBaseService(uid:user.uid ).updateName(userData.role,userData.isDriver,
                                       widget.dataNameToUpdate,
                                      userData.phone, userData.email,userData.address,);
                                  } else
                                  if(widget.hintText==userData.phone){
                                    //if Phone is what will be edited
                                   await DataBaseService(uid:user.uid ).updatePhone(
                                      userData.role,userData.isDriver,userData.name,
                                       widget.dataNameToUpdate,userData.email,userData.address,);
                                  } else
                                   if(widget.hintText==userData.email){
                                    //if Email is what will be edited
                                   await DataBaseService(uid:user.uid ).updateEmail(
                                     userData.role,userData.isDriver,userData.name,
                                      userData.phone, widget.dataNameToUpdate,userData.address,);
                                  }
                                   else if(widget.hintText==userData.address){
                                    //if Address is what will be edited
                                   await DataBaseService(uid:user.uid ).updateAddress(
                                      userData.role,userData.isDriver, userData.name,
                                      userData.phone, userData.email,widget.dataNameToUpdate);
                                   }
                                  //  else{
                                  //     await DataBaseService(uid:user.uid ).updateUserData(false,
                                  //      widget.dataNameToUpdate,widget.dataNameToUpdate,
                                  //      widget.dataNameToUpdate,widget.dataNameToUpdate,);
                                  //  }
                                   Navigator.pop(context);
                                }
                              },
                              placeHolder: 'Update ',
                              ),
                              //if user cancels editing
                              MyButton(
                                placeHolder: 'Cancel',
                              pressed:(){
                                Navigator.pop(context);
                              } 
                              )
                          
                ],
            ),
              ),
        );
                     }else{
                       return Loading();
                     }
                   }
                 );
        
      // if(widget.formKey.currentState.validate()){
                                //   if(widget.hintText==userData.name){
                                //     //if name is what will be edited, is passed as the hint text and 
                                //     //the hint is equal to the name in the dataBase
                                //       await DataBaseService(uid:user.uid ).updateName(
                                //        widget.dataNameToUpdate);
                                //   }
                                //   if(widget.hintText==userData.phone){
                                //     //if Phone is what will be edited
                                //    await DataBaseService(uid:user.uid ).updatePhone(
                                //        widget.dataNameToUpdate);
                                //   }
                                //    if(widget.hintText==userData.email){
                                //     //if Email is what will be edited
                                //    await DataBaseService(uid:user.uid ).updateEmail(
                                //        widget.dataNameToUpdate);
                                //   }
                                //    if(widget.hintText==userData.address){
                                //     //if Address is what will be edited
                                //    await DataBaseService(uid:user.uid ).updateAddress(
                                //        widget.dataNameToUpdate);
                                //   }
                                //  switch(widget.dataNameToUpdate){
                                //    case userData.address:
                                //   //  await DataBaseService(uid:user.uid ).updateName(
                                //   // widget.dataNameToUpdate);
                                //   print(widget.dataNameToUpdate);
                                //   break;
                                //   case 'phone':
                                //    await DataBaseService(uid:user.uid ).updatePhone(
                                //   widget.dataNameToUpdate);
                                //   break;
                                //   case 'email':
                                //    await DataBaseService(uid:user.uid ).updateEmail(
                                //   widget.dataNameToUpdate);
                                //   break;
                                //   case 'address':
                                //   print(widget.dataNameToUpdate);
                                //   break;
                                //  }
                                //   await DataBaseService(uid:user.uid ).updateData(
                                //   widget.dataNameToUpdate);
                                  
                                //     Navigator.pop(context);
   
  }
}