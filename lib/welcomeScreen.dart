import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticated.dart';
import 'models/user.dart';
import 'components/my_button.dart';
import 'auth_page.dart';
import 'components/loading.dart';
class WelcomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loading=false;
bool shouldPop = true;
 Future <bool> _onBackPressed(){
    
    return showDialog(
      context: context,
      builder:(context)=>AlertDialog(
        title:Text('Do You want to Exit?'),
        actions: <Widget>[
          RaisedButton(
            child: Text('no'),
            color: Color(MyApp().myred),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed:()=> Navigator.pop(context,false),
          ),
          RaisedButton(
            child: Text('Yes'),
            onPressed:()=> Navigator.pop(context,true),
          ),
        ]
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    
return
      WillPopScope(
        onWillPop: () async{
          return _onBackPressed();
        },
               child: Scaffold(
  
            //appBar:AppBar(title: Text('Dispatcher Rider'),
  
         // centerTitle:true ),
  
          body: Column (
  
            children: <Widget>[
  
              Container(
  
                padding: EdgeInsets.all(10.0),
  
                margin: EdgeInsets.all(25.0),
  
                child: Column(
  
                  children:<Widget>[ 
  
                    Text(
  
                      ' Dispacher Rider',
  
                      style: TextStyle(
  
                        fontSize: 35.0,
  
                        color: Colors.redAccent,
  
                        fontWeight: FontWeight.bold,
  
                      ),
  
                    ),
  
                    Text(
  
                      'Order a Rider to deliver Your Products in Minutes',
  
                      style: TextStyle(
  
                          fontSize: 12.0,
  
                        color: Color(int.parse("0xff54a2d6")),
  
                         fontWeight: FontWeight.bold,
  
                      ),
  
                    )
  
                  ]
  
                     ),
  
                  ),
  
              Container(
  
                padding: EdgeInsets.all(20.0),
  
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
             Navigator.push(context,
  
                    MaterialPageRoute(builder: (context) => AuthPage()));
  
                      setState(() => loading=true);
  
                           },
  
                      color: Color(int.parse("0xffe37029")),
  
                      child: Text(
  
                        'GET STARTED',
  
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
