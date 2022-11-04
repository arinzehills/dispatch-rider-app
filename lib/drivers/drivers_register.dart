import 'package:dispacher_app/components/bottomNav.dart';
import 'package:dispacher_app/drivers/drivers_dashboard.dart';
import 'package:dispacher_app/drivers/drivers_login.dart';
import 'package:dispacher_app/login.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/phone_number.dart';
import 'package:dispacher_app/auth_page.dart';
import 'package:dispacher_app/components/no_account.dart';
import 'package:dispacher_app/services/drivers_auth.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/components/constants.dart';
import 'package:dispacher_app/components/loading.dart';

class DriversRegister extends StatefulWidget {
  @override
  _DriversRegisterState createState() => _DriversRegisterState();
}

class _DriversRegisterState extends State<DriversRegister> {
  final AuthService _auth= AuthService();

  final _formKey = GlobalKey<FormState>();
  String name;
  String email='';

  bool obscureText=true;

    bool loading=false;

  String password='';

  String confirmPassword='';

  String error='';
  Future <bool> _onBackPressed(){
    
    return Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => DriversLogin()),
                    );
  }
  @override
  Widget build(BuildContext context) {
    
    return 
    WillPopScope(
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
                        'DRIVERS Drivers',
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
                        Image.asset('assets/dispatch_app_icon.png')
              ),
                    
                      SingleChildScrollView(
                           child: Form(
                                key: _formKey,
                                      child: Column(
                               children: <Widget>[
                                  TextFormField(
                                    validator: (val)=> val.isEmpty ? 'Enter an Email' : null,
                                  decoration: textFieldDecoration.copyWith(
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
                              height:10,
                          ),
                          TextFormField(
                            validator: (val)=> val.length < 6 ? 'Password must be 6 character long' : null,
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
                                        setState(() =>password =val);
                                    },  
                          ),
                         SizedBox(
                              height:10,
                          ),
                          TextFormField(
                            validator: (val)=> val!=password ? 'Password must be the same' : null,
                                    obscureText: obscureText,
                                  decoration: textFieldDecoration.copyWith(
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
                                      hintText: 'Confirm Password',
                                  ) ,
                                    onChanged: (val){
                                        setState(() =>confirmPassword =val);
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
                                        dynamic result= await _auth.driversRegister(email, password);
                                        if(result==null){
                                          setState(() {
                                            error= 'please supply a valid email';
                                            loading=false;
                                          });
                                        }
                                        else{
                                          Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>BottomNav()));
                                        }
                                     }
                                     else{
                                      print('error sign');
                                     }
                                        },
                                    color: Color(int.parse("0xffe37029")),
                                    child: Text(
                                      'SIGN UP',
                                        style:TextStyle(
                                          color:Colors.white,
                                        ),

                                    ),
                                  ),

                                ),
                                ),
                        // NoAccount(title: ' Sign In',subT: 'Have Drivers acoount',
                        // pressed: (){
                        //   Navigator.push(context,
                        //           MaterialPageRoute(builder: (context) =>Login()));
                        // },
                        // )
                  ]
                     ),
                  ),
          ],
        ),
      ),
    );
  }
}
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
      Key key, 
      this.child
          }) : super( key: key);
  @override
  Widget build(BuildContext context) {
    
    return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical:5),
              width:  240,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse("0xffffa693")),
                borderRadius: BorderRadius.circular(29),
              ),
            );
  }
}