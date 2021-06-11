import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/models/user.dart';
class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user){
    return user !=null ? Users(uid: user.uid) : null;
  }
    //auth change user stream
    Stream<Users> get user{
        return  _auth.authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
    }
  Future signInAnon() async{
    try {
      UserCredential result=  await _auth.signInAnonymously();
      User user=result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //Register
    
  Future register(String email, String password) async{
      try { 
        
        UserCredential result=  await _auth.
                                createUserWithEmailAndPassword(email: email, password: password);
       User user=result.user;
      //  create new document for the user with uid
      await DataBaseService(uid: user.uid).updateUserData('normalUser','false','Arinze', '082932', 'bosso',user.email);
          return _userFromFirebaseUser(user);
      } catch(e){
        print(e.toString());
        return null;
      }
    }
     Future driversRegister(String email, String password) async{
      try { 
        
        UserCredential result=  await _auth.
                                createUserWithEmailAndPassword(email: email, password: password);
          User driver=result.user;
      //  create new document for the user with uid
      await DataBaseService(uid: driver.uid).updateUserData('normalUser','true','User Name', '8146596444', 'bosso',driver.email);
          return _userFromFirebaseUser(driver);
      } catch(e){
        print(e.toString());
        return null;
      }
    }
    //SIGN In 
    Future signIn(String email, String password) async{
      try { 
        
        UserCredential result=  await _auth.
                                signInWithEmailAndPassword(email: email, password: password);
          User user=result.user;

          return _userFromFirebaseUser(user);
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
 class UserHelper {
    static FirebaseFirestore _db= FirebaseFirestore.instance;
    static saveUser(User user) async{
      Map<String, dynamic> userData={
          "name": user.displayName,
          "email": user.email,
          "role": "user",
      };
      final userRef=_db.collection("users").doc(user.uid);
      if((await userRef.get()).exists){

      }else{
        userRef.set(userData);
      }
    }
  }