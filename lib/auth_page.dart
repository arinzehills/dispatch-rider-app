import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'components/loading.dart';
import 'welcomeScreen.dart';
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading=false;
  bool pop=true;
  
Future <bool> _onBackPressed(){
    
    return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    WelcomeScreen()), (Route<dynamic> route) => false);
  }
  @override
  Widget  build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async{
          return _onBackPressed();
        },
          child: loading ? Loading() :Scaffold(
        body: Column (
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.fromLTRB(25.0,50,25.0,5.0),
                child: Column(
                  children:<Widget>[ 
                    
                    Center(
                          child: Text(
                        'WELCOME',
                        style: TextStyle(
                            fontSize: 22.0,
                          color: Color(int.parse("0xff54a2d6")),
                           fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]
                     ),
                  ),
              Container(
                padding: EdgeInsets.all(20.0),
                  height: 320,
                  child:
                  Image.asset('assets/delivery1.png')
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child:RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      onPressed:(){
                          setState(() {
                            loading=true;
                            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login()));
                          });
                      
                           },
                      color: Color(int.parse("0xffe37029")),
                      child: Text(
                        'lOGIN',
                          style:TextStyle(
                            color:Colors.white,
                          ),

                      ),
                    ),

                  ),
                  ),
                //container for sign up button
                Container(
                                padding: EdgeInsets.all(20.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child:RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    onPressed:(){
                                    Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Register()));
                                      setState(() {
                                         loading=true;
                                      });
                                        },
                                    color: Color(int.parse("0xffffa693")),
                                    child: Text(
                                      'SIGN UP',
                                        style:TextStyle(
                                          color:Colors.white,
                                        ),

                                    ),
                                  ),

                                ),
                                )

            ]


        )
      ),
    );
  }
}