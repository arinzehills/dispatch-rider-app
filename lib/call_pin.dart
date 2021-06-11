import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/login.dart';
import 'package:flutter/material.dart';

class CallPin extends StatefulWidget {
  @override
  _CallPinState createState() => _CallPinState();
}

class _CallPinState extends State<CallPin> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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
                      'Confirm Phone',
                      style: TextStyle(
                          fontSize: 22.0,
                        color: Color(int.parse("0xff54a2d6")),
                         fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   Container(
                      padding: EdgeInsets.all(20.0),
                     height: 130,
                      child:
                      Image.asset('assets/delivery2.png')
            ),
                  
                    SingleChildScrollView(
                         child: Column(
                           children: <Widget>[
                              
                        TextField(
                                obscureText: true,
                              decoration: InputDecoration(
                                 prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(int.parse("0xffffffff")),
                                  ),
                                   suffixIcon: Icon(
                                  Icons.visibility,
                                  color: Color(int.parse("0xffffffff")),
                                  ),
                                hintText: 'Enter Pin Code',
                                 hintStyle: TextStyle(color: Colors.white),
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
                      
                                
                           ],
                         )
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
                                MaterialPageRoute(builder: (context) =>Authenticated()));
                                      },
                                  color: Color(int.parse("0xffe37029")),
                                  child: Text(
                                    'Pin Code',
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
    );
    }
}