import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/components/my_button.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:dispacher_app/users/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TestFile extends StatefulWidget {
  

  @override
  _TestFileState createState() => _TestFileState();
}
 
// class Orders {
//   final message;
//   final customersName;
//   final uid;
//   final user;
//   const Orders(this.message, this.customersName, this.uid, this.user);
// }
class Orders {
  final String driversName;
  final String driversuid;
  
  final String message;
  final DateTime customersName;
  final String customersuid;
  // final DocumentReference reference;
    Orders({this.driversName,this.driversuid, this.message,this.customersName
              ,this.customersuid});
  // Orders.fromMap(Map<String, dynamic> map, {this.reference})
  //     : driversName = map['driversName'],
  //       driversuid = map['driversuid'],
  //       message = map['messages'],
  //       customersName = (map['customersName'] ),
  //       uid = map['uid'];

  // Orders.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // @override
  // String toString() {
  //   return 'Messages{messages: $message, customersName: $customersName, uid: $uid, reference: $reference}';
  // }
}

class Users {
  final String uid;
  final String name;
  // final DocumentReference reference;
      Users({this.uid,this.name});
  // Users.fromMap(Map<String, dynamic> map, {this.reference})
  //     : uid= map['uid'],
  //        name = map['name'];

  // Users.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // @override
  // String toString() {
  //   return 'Users{name: $name, reference: $reference}';
  // }
}


class _TestFileState extends State<TestFile> {
  String uid;
  final CollectionReference usersCollection=FirebaseFirestore.instance.collection('users');
  final CollectionReference ordersCollection=FirebaseFirestore.instance.collection('orders');

  Users _userDataFromSnapshot(DocumentSnapshot snapshot){
          dynamic  data= snapshot.data();
          
            return Users(
              uid: uid,
            name:data['userName'] ?? '',
            
          );

    }
   Orders _ordersDataFromSnapshot(DocumentSnapshot snapshot){
          dynamic  data= snapshot.data();
          
            return Orders(
              driversuid: uid,
            customersuid:data['CurrentUserId'] ?? '',
            
          );

    }
  final  _service = FirebaseFirestore.instance;
  Stream<Users> get _usersStream{
      return usersCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot );
    }
  
   Stream<List<Orders>> _orderStream;
   retrieveUsers(){
   return FirebaseFirestore.instance
    .collection('users')
    .get()
    .then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) => {
       doc.data()['userName']
      })
    });
    }
    Widget build(BuildContext context) {
    var user=FirebaseAuth.instance.currentUser;
      
    
    // DocumentSnapshot  document=;
    //               dynamic data=document.data();
      return StreamBuilder<QuerySnapshot>(
        
      stream:FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
                  body: new ListView(

            
            children: snapshot.data.docs.map((DocumentSnapshot document) {
               dynamic  data= document.data();
              return new ListTile(
                title: new Text(data['message'] ?? 'sda'),
                );
            }).toList(),
          ),
        );
      }
      );
    }
}

// @override
//    void initState(){
//      retrieveUsers();
//    }
//   Stream<QuerySnapshot> get ordersStream{
//     Stream<QuerySnapshot> stream=FirebaseFirestore.instance
//     .collection('users').snapshots();
//     stream.forEach((result) {
//       final user= Provider.of<Users>(context);
//       Stream<QuerySnapshot> orderStream= FirebaseFirestore.instance 
//         .collection("orders")
//         .doc()
//         .collection("user_orders")
//         .where('driversuid', isEqualTo: user.uid).snapshots();
//         orderStream.forEach((element) {
//            return element;
//         }); 
//      });
    
//   }
//  Widget build(BuildContext context) {
//     var user=FirebaseAuth.instance.currentUser;
     
//     String retrieveUsers(){
//    return FirebaseFirestore.instance
//     .collection('users')
//     .get()
//     .then((querySnapshot) => {
//       querySnapshot.docs.forEach((doc) => {
//        doc.data()['uid']
//       })
//     }).toString();
    
//     }
    
//     // DocumentSnapshot  document=;
//     //               dynamic data=document.data();
//       return StreamBuilder<QuerySnapshot>(
        
//       stream: FirebaseFirestore.instance
//             .collection('orders')
//             .doc()
//             .collection('user_orders')
//             .where('driversuid', isEqualTo: user.uid)
//             .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading");
//         }

//         return Scaffold(
//                   body: new ListView(

            
//             children: snapshot.data.docs.map((DocumentSnapshot document) {
//                dynamic  data= document.data();
//               return new ListTile(
//                 title: new Text(data['message'] ?? 'sda'),
//                 );
//             }).toList(),
//           ),
//         );
//       }
//       );
    