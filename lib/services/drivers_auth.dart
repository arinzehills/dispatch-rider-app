import 'package:dispacher_app/models/drivers.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/models/user.dart';
class DriversAuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  bool isDriver=false;

  Drivers _driversFromFirebaseUser(User driver){
    return driver !=null ? Drivers(uid: driver.uid) : null;
  }
    //auth change Driver stream
    Stream<Drivers> get driver{
        return  _auth.authStateChanges()
        .map((User driver) => _driversFromFirebaseUser(driver));
    }
  Future signInAnon() async{
    try {
      UserCredential result=  await _auth.signInAnonymously();
      User driver=result.user;
      return driver;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //Register
    
  Future driversRegister(String email, String password) async{
      try { 
        
        UserCredential result=  await _auth.
                                createUserWithEmailAndPassword(email: email, password: password);
          User driver=result.user;
      //  create new document for the user with uid
      // await DataBaseService(uidi: driver.uid).updateDriversData('normalUser','true','Arinze', '082932', 'bosso',driver.email);
          return _driversFromFirebaseUser(driver);
      } catch(e){
        print(e.toString());
        return null;
      }
    }
    //SIGN In 
    Future driversSignIn(String email, String password) async{
      try { 
        
        UserCredential result=  await _auth.
                                signInWithEmailAndPassword(email: email, password: password);
          User user=result.user;

          return _driversFromFirebaseUser(user);
      } catch(e){
        print(e.toString());
        return null;
      }
    }
  //signout
     Future signOut() async{
    try { 
      
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}