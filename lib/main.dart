import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/screens/homepage.dart';
import 'package:project/screens/signup.dart';
import 'screens/login.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // AwesomeNotifications().initialize(null, [NotificationChannel(
  //     channelGroupKey: "basic_channel_group",
  //     channelKey: "basic_channel",
  //     channelName: "task",
  //     channelDescription: "Task due time")]);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  // channelGroups :
  // [
  //   NotificationChannelGroup(
  //       channelGroupKey: "basic_channel_group",
  //       channelGroupName: "basic Group")
  // ];

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? Homepage() : Login(),
      routes:
      {
        "/login" : (context) => Login(),
        "/signin" : (context) => SignUp(),
        "/homepage" : (context) => Homepage(),
      },
    );
  }
}



