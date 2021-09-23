import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInProvider extends ChangeNotifier {
  bool signIn = true;

  void setSignIn(bool value) {
    this.signIn = value;
    notifyListeners();
  }
}
