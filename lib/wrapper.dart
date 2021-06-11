import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispacher_app/admin/admin_dashboard.dart';
import 'package:dispacher_app/components/bottomNav.dart';
import 'package:dispacher_app/models/usersDetail.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:dispacher_app/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticated.dart';
import 'models/user.dart';
import 'services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final user= Provider.of<Users>(context);
     if(user==null){
       return WelcomeScreen();
     } 
     else{
        return StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null){
              UserHelper.saveUser(snapshot.data);
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users')
                .doc(snapshot.data.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>
                  snapshots){
                     if(snapshot.hasData && snapshot.data != null){
                       final dynamic user = snapshots.data.data();
                       if(user['role']=='admin'){
                         return AdminDashboard();
                       }
                       else{
                         return Authenticated();
                       }
                     }
                     return Material(child: Center(child: CircularProgressIndicator()),
                      );
                      },
                  
              );
            }
            
          }
        );
     
      //  return StreamBuilder<Object>(
      //    stream: DataBaseService(uid: user.uid).userData,
      //    builder: (context, snapshot) {
      //      if(snapshot.hasData){
      //     UsersDetail userData= snapshot.data;
      //       if(userData.isDriver==true){
              
      //         return Authenticated();
      //       }
      //       else{
      //         return BottomNav();
      //      }
      //      }
      //    }
      //  );
     }
  }
}

