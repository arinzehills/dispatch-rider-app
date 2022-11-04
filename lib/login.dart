import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/drivers/drivers_login.dart';
import 'package:dispacher_app/register.dart';
import 'package:dispacher_app/services/drivers_auth.dart';
import 'package:dispacher_app/users/reset.dart';
import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'package:dispacher_app/components/no_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/constants.dart';
import 'package:dispacher_app/services/auth.dart';
import 'components/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
    final AuthService _authService= AuthService();

  final _formKey = GlobalKey<FormState>();
    //state of text field
    String email='';
    String password='';
    String error='';
    bool obscureText=true;
      bool loading=false;
      
   
     Future <bool> _onBackPressed(){
    
    return Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => Login()),
                     );
  }
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
          onWillPop: ()=>_onBackPressed(),
        child: loading ? Loading() : Scaffold(
        resizeToAvoidBottomInset: true,
        body:Center(
          child: SingleChildScrollView(
                      child: Column(
              children:<Widget> [
                Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(25.0,50,25.0,5.0),
                    child: Column(
                      children:<Widget>[ 
                        
                        Center(
                              child: Text(
                            'LOGIN',
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
                              TextFormField(
                                validator: (val)=> val.length < 6 ? 'Enter a valid password' : null,
                                        obscureText: obscureText,
                                      decoration:textFieldDecoration.copyWith(
                                          prefixIcon: Icon(
                                          Icons.lock,
                                          color: iconsColor,
                                          ),
                                           
                                        suffixIcon: IconButton(
                                              icon: const Icon(Icons.visibility),
                                              color:iconsColor,
                                              onPressed: () {
                                               if(obscureText==true){
                                                  setState(() {
                                                    obscureText=false;
                                                  });
                                                }
                                                else{
                                                  setState(() {
                                              obscureText=true;   
                                                });
                                                }
                                              },
                                          ),
                                          hintText: 'Enter Password',
                                      ) ,
                                        onChanged: (val){
                                            setState(() =>password=val);
                                        },
                              ),   
                                Text(
                                        error,
                                        style: TextStyle(color: Colors.red),
                                        ),                  
                                   ],
                                 ),
                               )
                        ),
                        //forgot password container
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed:(){
                                Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>ResetPassword()));
                              },
                               child: Text('Forgot Password'))
                          ],
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
                                            dynamic result= await _authService.signIn(email.toLowerCase().trim(), password.trim());
                                            if(result==null){
                                              setState(() {
                                                error= 'Error Login In';
                                                 loading=false;
                                              });
                                            }
                                            else{
                                            
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                                Authenticated()), (Route<dynamic> route) => false);
                                            }
                                         }
                                            },
                                        color: Color(int.parse("0xffe37029")),
                                        child: Text(
                                          'SIGN IN',
                                            style:TextStyle(
                                              color:Colors.white,
                                            ),

                                        ),
                                      ),

                                    ),
                                    ),
                                    NoAccount(title: ' Register',subT:"Dont Have an Account",
                                    
                                      pressed: (){
                                        setState(() => loading=true);
                                        Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>Register()));
                                    },
                                    
                            ),
                           
                      ]
                         ),
                      ),
                      SizedBox(height:70),
                      NoAccount(title: ' Login as rider',subT:'',
                                    
                                      pressed: (){
                                        setState(() => loading=true);
                                        Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>DriversLogin()));
                                    },
                                    )
              ],
            ),
          ),
        ),
      ),
   );
  }
}