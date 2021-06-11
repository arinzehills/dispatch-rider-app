import 'package:dispacher_app/authenticated.dart';

import 'package:dispacher_app/call_pin.dart';
import 'package:flutter/material.dart';
import 'auth_page.dart';

class PhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Column(
        children:<Widget> [
          Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.fromLTRB(25.0,50,25.0,5.0),
              child: Column(
                children:<Widget>[ 
                  
                  Center(
                        child: Text(
                      'Enter Phone',
                      style: TextStyle(
                          fontSize: 22.0,
                        color: Color(int.parse("0xff54a2d6")),
                         fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   Container(
                      padding: EdgeInsets.all(20.0),
                     height: 150,
                      child:
                      Image.asset('assets/delivery2.png')
            ),
                  
                    SingleChildScrollView(
                         child: Column(
                           children: <Widget>[
                              TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Phone',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person,
                                color: Color(int.parse("0xfafafafa")),
                                ),
                                filled: true,
                                fillColor:  Color(int.parse("0xffffa693")),
                                focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0),
                               ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                                  ),        
                           ),
                                
                        ),
                        SizedBox(
                          height:20,
                        ),
                        
                Container(
                              padding: EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child:RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  onPressed:(){
                                  Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CallPin()));
                                      },
                                  color: Color(int.parse("0xffe37029")),
                                  child: Text(
                                    'Enter Number',
                                      style:TextStyle(
                                        color:Colors.white,
                                      ),

                                  ),
                                ),

                              ),
                              )
                ]
                   ),
                ),
        ],
          ),
          ),
          ]
      )
    );
  }
}