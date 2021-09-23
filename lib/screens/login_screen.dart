import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:videochatapp/providers/signInProvider.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/home_screen.dart';
import 'package:videochatapp/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = new FirebaseRepository();
  bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Stack(
          children: [
            Center(child: loginButton()),
            isLoginPressed
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(UniversalVariables.blackColor),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: UniversalVariables.senderColor,
        child: Text(
          "Login",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
      ),
      onPressed: () => performLogin(),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((UserCredential? user) {
      if (user != null) {
        authenticateUser(user);
        Provider.of<SignInProvider>(context, listen: false).setSignIn(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(UserCredential credential) async {
    await _repository.authenticateUser(credential).then((value) {
      if (value) {
        return _repository.addDataToDb(credential);
      }
    });
  }
}
