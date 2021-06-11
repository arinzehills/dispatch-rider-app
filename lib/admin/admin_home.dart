import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:dispacher_app/drawer.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
    return StreamBuilder<UsersDetail>(
       stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UsersDetail userData= snapshot.data;
        return Scaffold(
           drawer: MyDrawer(),
          appBar:AppBar(
            title: Text('Admin Dashboard'),
           backgroundColor: Color(MyApp().myred),
           centerTitle:true,
          ),
          body:Column(
            children:<Widget> [
                DashboardCard(
                  context: context,
                  headText: 'Hi ',
                  userName: userData.name,
                  email: ' ' + userData.email,
                  role: 'admin',
                  color: Colors.deepOrangeAccent,
                  ),
                  Row(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('isDriver', isEqualTo: 'true')
                          .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return  Loading();
                          }
                          if(snapshot.hasData){
                          return DashboardCard(
                          context: context,
                          userName: 'Drivers',
                          color: Colors.accents[0],
                          width: 180,
                          mediateText: '0',
                          widget: Text(
                                       snapshot.data.size.toString(),
                                       style: TextStyle(
                                         color:Colors.white, 
                                         fontSize: 60),
                                       ),
                          );
                          }
                          else {
                                   return  CircularProgressIndicator();
                                 }
                        }
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                          
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                              return  Loading();
                            }
                            if(snapshot.hasData){
                          return DashboardCard(
                          context: context,
                          userName: 'Users',
                          color: Colors.accents[3],
                          width: 180,
                          widget: Text(
                                       snapshot.data.size.toString(),
                                       style: TextStyle(
                                         color:Colors.white, 
                                         fontSize: 60),
                                       ),
                          );
                            }
                          else {
                                   return Center(child: CircularProgressIndicator.adaptive());
                                 }
                        }
                      ),
                    ],
                  ),
                Spacer(),
                        ]
                      ) 
                    );
      }else{
        return Loading();
      }
      }
    );
              }
            //dashboard card method
        
}

class DashboardCard extends StatelessWidget {
  final double height;
  final String headText;
final double width;
final String userName;
final Color color;
  final String email;

  final String role;
final Widget widget;
  final String mediateText;
  
  const DashboardCard({
    this.userName,
    this.headText,
    this.mediateText,
    this.role,
    this.email,
    this.widget,
    this.width,
    this.height,
    this.color,
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
            return   SizedBox(
          // height: 251,
          height:height,
          width: width,
          child: Card(
            
          color:color,
            margin: EdgeInsets.fromLTRB(10,16,16,16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                
                children: [
                    Row(
                      children: [
                            Text(
                              headText ?? '',
                              style: TextStyle(
                              fontSize: 32.0,
                                  color: Color(int.parse("0xff54a2d6")),
                                fontWeight: FontWeight.bold, 
                                ),
                            ),
                            Text(
                              userName ?? '' + '!',
                              style: TextStyle(
                              fontSize: 32.0,
                                  color: Color(int.parse("0xff54a2d6")),
                                fontWeight: FontWeight.bold, 
                                                ),  
                                 )
                               ],
                        ),
                        Row(
                          children: [
                           Padding(
                             padding: const EdgeInsets.only(left:50, bottom: 1),
                             child: widget ?? SizedBox()
                           )
                          ],
                        ),
               Row(
                      children: [
                            Row(
                              children:<Widget> [
                                Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                Text(
                                email ?? '',
                                  style: TextStyle(
                                      color: Colors.white, 
                                    fontSize: 15
                                    ),
                                ),
                                
                              ],
                            ),
                            Spacer(),
                            
                            FlatButton.icon(
                                  onPressed: (){
                          //           Navigator.of(context).push(
                          // MaterialPageRoute(builder: (context) => DriversDashboard()));
                                  },
                                  icon: Icon(Icons.pending_actions, color: Colors.white,), 
                                  label: Text(
                                    role ?? '',
                                   maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                    ),
                                )
                      ],
                    ),
                    
                   
                  ],
                  
                ),
              ),
            ),
            
          );
  
  }
}