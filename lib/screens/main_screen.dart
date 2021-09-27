import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videochatapp/providers/signInProvider.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/search_screen.dart';
import 'home_screen.dart';
import 'login_screen_rahul.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository _firebaseRepository = new FirebaseRepository();
    /*if (FirebaseAuth.instance.currentUser == null) {
      Provider.of<SignInProvider>(context, listen: false).setSignIn(false);
    }*/
    return MaterialApp(
      title: "Video Chat",
      initialRoute: '/',
      theme: ThemeData(brightness: Brightness.dark),
      routes: {
        SearchScreen.routeName: (context) => SearchScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<User?>(
          future: _firebaseRepository.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (Provider.of<SignInProvider>(context).signIn) {
                return HomeScreen();
              } else {
                return MyLoginPage();
              }
            } else {
              return MyLoginPage();
            }
          }),
    );
  }
}
