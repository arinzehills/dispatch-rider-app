
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/authenticated.dart';
import 'package:dispacher_app/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestFile extends StatefulWidget {
  @override
  _TestFileState createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> {
  Stream<QuerySnapshot>  getDriversSnapshot(BuildContext context) async* {
     
    yield* FirebaseFirestore.instance
                        .collection('users')
                        .where('isDriver', isEqualTo: 'true')
                       .snapshots();
                      
   }

   getUser() async{
    //  final Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = await FirebaseFirestore.instance.collection('users')
    //                                       .where('isDriver', isEqualTo: 'true')
    //                                       .snapshots();
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshot=FirebaseFirestore.instance
    .collection('users')
    .where('driver', isEqualTo: 'true').snapshots();

    // .get().then((QuerySnapshot docs){
    //     if(docs.docs.isEmpty){
    //       print('is Empty');
    //     }
    //     else{
    //       final drivers=Provider.of(context).docs();
    //       print(drivers.size);
    //     }
    //  });    
   }
   @override
   void initState(){
     getUser();
     super.initState();
   }
    Future <bool> _onBackPressed(){
    
    return   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
   Authenticated()), (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> stream=FirebaseFirestore.instance
    .collection('users')
    .where('driver', isEqualTo: 'true').snapshots();
      return StreamBuilder<QuerySnapshot>(
      stream: stream,
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
                title: new Text(data['userName']),
                );
            }).toList(),
          ),
        );
      }
      );
  }}
  //     StreamBuilder(
  //       stream:  getDriversSnapshot(context),
  //       builder: (context,snapshot) { 
  //         if(snapshot.hasData){
  //         return ListView.separated(
  //           padding: const EdgeInsets.fromLTRB(0,1,8,1),
  //           itemCount: snapshot.data.documents.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return snapshot.data.querySnapshot[index];
  //            },  separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,),
  //           );
  //         }
  //         return Loading();
  //       }
  //     );
  // }
