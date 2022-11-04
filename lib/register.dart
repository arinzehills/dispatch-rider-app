import 'package:dispacher_app/components/my_button.dart';
import 'package:dispacher_app/login.dart';
import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/phone_number.dart';
import 'auth_page.dart';
import 'package:dispacher_app/components/no_account.dart';
import 'services/auth.dart';
import 'models/user.dart';
import 'components/constants.dart';
import 'components/loading.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth= AuthService();

  final _formKey = GlobalKey<FormState>();
  String name='';
  String email='';
  String phone='';
  bool obscureText=true;

    bool loading=false;

  String password='';

  String confirmPassword='';

  String error='';
  Future <bool> _onBackPressed(){
    
    return Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => AuthPage()),
                    );
  }
  void validate(){
        if(_formKey.currentState.validate()){

        }
        else{

        }
     }
     String validatephone(val){
        if( val.length < 11  ) 
        {
          return ' Phone number must not be less than 11 characters';
        } 
        else if( val.isEmpty){
              return 'Enter a Phone number';
              }
              else{
          return null;
        }
           }
  @override
  Widget build(BuildContext context) {
    
    return 
    WillPopScope(
       onWillPop: ()=>_onBackPressed(),
          child: loading ? Loading() : Scaffold(
        resizeToAvoidBottomInset: true,
        body:Center(
          child: SingleChildScrollView(
                     child:
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                   
                    child: Column(
                       mainAxisSize: MainAxisSize.min,
                      children:<Widget>[ 
                        
                        Center(
                              child: Text(
                            'REGISTER',
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
                                autovalidateMode: AutovalidateMode.always,
                                    key: _formKey,
                                          child: Column(
                                   children: <Widget>[
                                     TextFormField(
                                        validator: (val)=> val.isEmpty ? 'Please Enter a Name' : null,
                                      decoration: textFieldDecoration.copyWith(
                                          prefixIcon: Icon(
                                          Icons.person,
                                          color: iconsColor,
                                          ),
                                          hintText: 'Enter Name',
                                                 ) ,
                                        onChanged: (val){
                                            setState(() =>name =val);
                                        },  
                              ),
                                SizedBox(
                                  height:10,
                              ),
                                      TextFormField(
                                        validator: MultiValidator(
                                          [
                                            RequiredValidator(errorText: 'Required'),
                                            EmailValidator(errorText: "Enter a Valid Email")
                                          ]
                                        ),
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
                                        validator:MultiValidator(
                                          [
                                            RequiredValidator(errorText: 'Required'),
                                             MinLengthValidator(11, errorText: 'Phone number must be at least 11 digits long'),
                                          ]
                                        ),
                                      decoration: textFieldDecoration.copyWith(
                                          prefixIcon: Icon(
                                          Icons.call,
                                          color: iconsColor,
                                          ),
                                          hintText: 'Enter Phone',
                                                 ) ,
                                        onChanged: (val){
                                            setState(() =>phone =val);
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
                      
                      MyButton(
                        placeHolder: 'SIGN UP',
                        pressed: () async{
                                         
                                         if(_formKey.currentState.validate()){
                                            setState(() => loading=true);
                                            dynamic result= await _auth.register(email.toLowerCase().trim(), 
                                              password.trim(),phone.trim(),name.trim());
                                            if(result==null){
                                              setState(() {
                                                error= 'please supply a valid email';
                                                loading=false;
                                              });
                                            }
                                            else{
                                              Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>Login()));
                                       ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Color(MyApp().myred),
                                                    content: Text('Registered Successfully, Login')
                                                      )
                                                );
                                            }
                                         }
                                         else{
                                          print('error sign');
                                         }
                                            },
                      ),
                            NoAccount(title: ' Sign In',subT: 'Have an account',
                            pressed: (){
                              Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>Login()));
                            },
                            )
                      ]
                         ),
                      ),
              
          ),
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