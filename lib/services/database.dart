
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/models/driversDetail.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DataBaseService{
//collection reference
    //normal users collection  refrenrence
    final CollectionReference usersCollection=FirebaseFirestore.instance.collection('users');
    //normal Drivers collection  refrenrence
    // final CollectionReference driversCollection=FirebaseFirestore.instance.collection('drivers');

  final String uid;
   final String dataName; 
  LocationData _currentPosition;
  String _address,_dateTime;
  Location location = Location();
  Geoflutterfire geo = Geoflutterfire();
  var firestore = FirebaseFirestore.instance;
    DataBaseService({
      this.uid,
      this.dataName,
    });
//if name is what will be edited
            Future updateName(role,String isDriver,name,phone,String email,address,) async {
             
      return await usersCollection.doc(uid).set({
        'email' :email,
        'userName' :name,
        'phone': phone,
       'address': address,
        'isDriver' : isDriver,
        'role'  :role,
      });
      }
      //if phone is what will be edited
      Future updatePhone(role,String isDriver,name,phone,String email,address) async {
      return await usersCollection.doc(uid).set({
       'email' :email,
        'userName' :name,
        'phone': phone,
       'address': address,
        'isDriver' : isDriver,
        'role'  :role,
      });
    }
    //if email is what will be edited
    Future updateEmail(role,String isDriver,name,phone,String email,address) async {
      return await usersCollection.doc(uid).set({
        'email' :email,
        'userName' :name,
        'phone': phone,
       'address': address,
        'isDriver' : isDriver,
        'role'  :role,
      });
    }
    //if name is what will be edited
  Future updateAddress(role,String isDriver,name,phone,String email,address) async {
        return await usersCollection.doc(uid).set({
          'email' :email,
        'userName' :name,
        'phone': phone,
       'address': address,
        'isDriver' : isDriver,
        'role'  :role,
        });
      }
    Future updateUserData(role,String isDriver,String userName, String phone,String address,String email) async {
          var status = await OneSignal.shared.getPermissionSubscriptionState();
          String tokenId = status.subscriptionStatus.userId;
                                        
      return await usersCollection.doc(uid).set({
            'uid':uid,
            'isDriver' : isDriver,
            'role'  :role,
            'userName' : userName,
            'phone': phone,
          'address': address,
          'email' :email,
          
          });
        }
    // users data from snapshot
    UsersDetail _userDataFromSnapshot(DocumentSnapshot snapshot){
          dynamic  data= snapshot.data();
            return UsersDetail(
              uid: uid,
            name:data['userName'] ?? '',
            phone: data['phone'] ?? '',
            address: data['address'] ?? '',
            email: data['email'] ?? '',
           isDriver: data['isDriver'] ?? '',
           role: data['role'],
           
          );

    }
  //get users Stream
    Stream<UsersDetail> get userData{
      return usersCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot );
    }
    //users location
  
    
    Future<DocumentReference> _addGeoPoint() async {
     await Firebase.initializeApp();
  var pos = await location.getLocation();
  GeoFirePoint point = geo.point(latitude: 0.5937, longitude:  0.9629);
  return firestore.collection('users')
        .add({ 
    'position': point.data,
     
  });
}
 Future<List<geocoder.Address>> _getAddress(double lat, double lang) async {
    final coordinates = new geocoder.Coordinates(lat, lang);
    List<geocoder.Address> add =
    await geocoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
          }
    //update drivers data when registered 
// Future updateDriversData(String role,String isDriver,String userName, String phone,String address,String email) async {
//       return await usersCollection.doc(uid).set({
//         'role' : role,
//         'userName' : userName,
//         'phone': phone,
//        'address': address,
//        'email' :email,
//        'driver':isDriver,
//       });
//     }
  //get Drivers Data/Details from snapshot
//   DriversData _driversDataFromSnapshot(DocumentSnapshot snapshot){
//           dynamic data=snapshot.data();  
//     return DriversData(
       
//           isDriver:data['isDriver'] ,
//          uid: uid,
//           name:data['name'] ,
//           phone:data['phone'],
//           email: data['email'],
//           address: data['address']

//     );
//   }
// //get Drivers Stream
//     Stream<DriversData> get driverData{
//       return usersCollection.doc(uid).snapshots()
//       .map(_driversDataFromSnapshot );
//     }

    // Stream<QuerySnapshot> get users{
    //   return usersCollection.snapshots();
    // }
  //  List<UsersDetail> _userDataFromSnapshot(DocumentSnapshot snapshot){
  //         return snapshot.docs.map((doc) { 
  //           return UsersDetail(
  //           // name:doc.data['name'] ?? '',
  //           // phone: doc.data['phone'] ?? '',
  //           // address: doc.data['address'] ?? '',
  //         );
  //         }).toList();

  //   }
}