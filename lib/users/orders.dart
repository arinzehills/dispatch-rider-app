import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/main.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
    
    
        return StreamBuilder(
          stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection('user_orders')
            .orderBy('TimeStamp', descending:true)
            .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.size==0){
                return Scaffold(
                    appBar: AppBar(title: Text('orders')),
      
                  body: Center(
                     child: Column(
                      children: [
                        Container(
                                  padding: EdgeInsets.all(20.0),
                                  child:
                                  Image.asset('assets/delivery6.png')
                        ),
                        Text(
                          'No Orders Yet!',
                          style: TextStyle(
                            color: Color(MyApp().myred),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            ),),
                       ],
                    )),
                   );
              }
              //if no orders
                else{
                   return 
                   Scaffold(
                    appBar: AppBar(title: Text('Your Orders')),
      
                  body: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(0,1,8,1),
              itemCount: snapshot.data.size, //documents.length,
              itemBuilder: (BuildContext context, int index) {
                //    snapshot.data.docs.map((DocumentSnapshot document) {
              //  dynamic  data= document.data();
                    DocumentSnapshot  document=snapshot.data.docs[index];
                    dynamic orderData=document.data();
              return Card(
                    child:ListTile(
                              title: Text( orderData['driversName'] ?? '',
                                        style: TextStyle(
                                          color: Color(MyApp().myred,),
                                          fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              subtitle: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Column(
                                  children: [
                                    Row(
                                          children: [
                                                    Icon(
                                                           Icons.date_range,
                                                          color: Colors.green,
                                                          size: 13,
                                                        ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: Wrap(
                                                      children: [
                                                        
                                                    Text(
                                                      ' '+orderData['Date'].toString(),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black, 
                                                            fontSize:10
                                                          ),
                                                    ),
                                                     ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                   SizedBox(
                                                     width: 50,
                                                     child: Wrap(
                                                       children: [
                                                    Text(
                                                    orderData['Time'] ?? 'Available',
                                                    overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize:10
                                                            ),
                                                    ),
                                                  ],
                                                     ),
                                                   ),
                                                  Icon(
                                                    Icons.lock_clock,
                                                    color: Colors.green,
                                                  ),
                                            ],
                                         ),
                                         Row(
                                          children: [
                                                    Icon(
                                                           Icons.location_on,
                                                          color: Colors.green,
                                                          size: 13,
                                                        ),
                                                  SizedBox(
                                                    width: 50,
                                                    child: Wrap(
                                                      children: [
                                                        
                                                    Text(
                                                      'Bosso dfdsadsadfdhgjhfhfjhfjh',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black, 
                                                            fontSize:10
                                                          ),
                                                    ),
                                                 
                                                     ],
                                                    ),
                                                  ),
                                                     FlatButton.icon(
                                      onPressed:() async{

                                       return FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(user.uid)
                                              .collection('user_orders')
                                              .doc(document.id)
                                              .delete();
                                      },
                                  icon: Icon(
                                    Icons.delete,
                                     color: Colors.red,), 
                                  label: Text(
                                    'DELETE',
                                   maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12
                                    ),
                                    ),
                                )
                                                  // Spacer(),
                                                  //  Text(
                                                  // 'Available',
                                                  //   style: TextStyle(
                                                  //       color: Colors.black,
                                                  //       fontSize:10
                                                  //     ),
                                                  // ),
                                                  // Icon(
                                                  //   Icons.toggle_on,
                                                  //   color: Colors.green,
                                                  // ),
                                            ],
                                         ),
                                  ],
                                ),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(-7,5,3, 5),
                              leading:  CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              child: Image.asset("assets/2.JPG")
                                            ),
                                         ),
                              onTap:() => {
                                // showDialog(context: context,
                                //     builder: (BuildContext context){
                                     

                                //      }        
                                //   ),
                              }),
                            );
                    },
            separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,),
                ),
                  ),
                   );
                }
            
            }
            //if it does not have data
            else{
             return Scaffold(
               appBar:AppBar(
                 title: Text('Orders'),
               ),
               body: Center(child: CircularProgressIndicator()),
               );
            }
          }
        );
     }
    
    
        }
  
 