import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dispacher_app/components/constants.dart';
import 'package:dispacher_app/services/auth.dart';
import 'package:dispacher_app/welcomeScreen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'wrapper.dart';
import 'package:dispacher_app/models/user.dart';
import 'package:http/http.dart' as http;
  

  
/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }
  
Future<void> main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
    runApp(MyApp());
  } 
  

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
     int myblue=int.parse("0xff54a2d6");

     int myred= int.parse("0xffe37029");
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
    //   FirebaseMessaging messaging;
    // @override
    // void initState() { 
    // super.initState();
    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value){
    //     print(value);
    // });
    // }
    @override
  void initState() {
    super.initState();
   
  }

  void configOneSignel()
  {
    // OneSignal.shared.init(appId);
  }
  
  @override
  Widget build(BuildContext context) {
    
     
    return 
        StreamProvider<Users>.value(
          initialData:null,
          value: AuthService().user,
          child: MaterialApp(
          home: Wrapper(),
      ),
    );

        }
}
