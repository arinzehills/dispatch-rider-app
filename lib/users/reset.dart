import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/login.dart';
import 'package:dispacher_app/register.dart';
import 'package:dispacher_app/services/drivers_auth.dart';
import 'package:flutter/material.dart';
import '../auth_page.dart';
import 'package:dispacher_app/components/no_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/constants.dart';
import 'package:dispacher_app/services/auth.dart';
import '../components/loading.dart';
import '../main.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
    final AuthService _authService= AuthService();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
    //state of text field
    String email='';
    String error='';
    bool obscureText=true;
      bool loading=false;
     Future <bool> _onBackPressed(){
    
    return Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => AuthPage()),
                     );
  }
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
          onWillPop: ()=>_onBackPressed(),
        child: loading ? Loading() : Scaffold(
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
                        'Reset Password',
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
                        Image.asset('assets/dispatch_app_icon.png')
              ),
                    
                      SingleChildScrollView(
                           child: Form(
                             key: _formKey,
                                    child: Column(
                                  children: <Widget>[
                                      TextFormField(
                                        validator: (val)=> val.isEmpty ? 'Enter an Email' : null,
                                      decoration:textFieldDecoration.copyWith(
                                      prefixIcon: Icon(
                                      Icons.person,
                                      color: iconsColor,
                                      ),
                                      hintText: 'Enter Email',
                                             ) ,
                                  onChanged: (val){
                                        setState(() =>email =val);
                                    },  
                          ),
                          SizedBox(
                              height:20,
                          ),
                            
                            Text(
                                    error,
                                    style: TextStyle(color: Colors.red),
                                    ),                  
                               ],
                             ),
                           )
                    ),
                  //button container
                  Container(
                                padding: EdgeInsets.all(20.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child:RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    onPressed:() async{
                                      if(_formKey.currentState.validate()){
                                        setState(() => loading=true);
                                        try {
                                            await _firebaseAuth.sendPasswordResetEmail(email : email.toLowerCase().trim(),);
                                       
                                      
                                        
                                          Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>Login()));
                                       ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Color(MyApp().myred),
                                                    content: Text('Changed Successfully, Login')
                                                      )
                                                );
                                        } catch (e) {
                                            setState(() {
                                                error= 'Your email is not valid';
                                                 loading=false;
                                              });
                                        }
                                       
                                        
                                     }
                                        },
                                    color: Color(int.parse("0xffe37029")),
                                    child: Text(
                                      'Send Request',
                                        style:TextStyle(
                                          color:Colors.white,
                                        ),

                                    ),
                                  ),

                                ),
                                ),
                                
                       
                  ]
                     ),
                  ),
                  
          ],
        ),
      ),
   );
  }
}