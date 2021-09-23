import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videochatapp/providers/signInProvider.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/main_screen.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SignInProvider()),
      ],
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainScreen();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
