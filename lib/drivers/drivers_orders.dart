import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/components/my_button.dart';
import 'package:dispacher_app/drivers/driver_profile_pop.dart';
import 'package:dispacher_app/drivers/drivers_location.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';
import 'package:provider/provider.dart';

class DriversOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<Users>(context);
    
    
        return StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance
            .collection('driverOrders')
            .doc(user.uid)
            .collection('orders')
            .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
                   QuerySnapshot  document=snapshot.data;
                  //  dynamic data=document.data();
                    // dynamic userData=document.data();
                  //  for(var values in document){
                  //    print(values);
                  //  }
                  document.docs.forEach((result) {
                    print(snapshot);
                   });
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
                              title: Text( orderData['CustomersName'] ?? '',
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
                                                      ' ' + orderData['Date'].toString(),
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
                                                    orderData['Time'].toString() ?? 'Available',
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
                                                      orderData['pickup location'] ?? '',
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
                                              .collection('driverOrders')
                                              .doc(user.uid)
                                              .collection('orders')
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
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                     return DriverDetails(
                                   
                                   title: orderData['CustomersName'],
                                    phone: orderData['CustomersPhone'] ?? '',
                                    pickuplocation: orderData['pickup location'] ?? '',
                                    userType:'Customer',
                                      trackDriver: () async{
                                         await Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => 
                                              DriversLocation(uid: orderData['Customeruid'],driversName:orderData['CustomersName'])));
                                      },
                                      placeHolder: 'Go Back',
                                      pressed: (){
                                        Navigator.pop(context);
                                      },                         
                                       
                                        
                                     );

                                     }        
                                  ),
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