import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:videochatapp/models/message.dart';
import 'package:videochatapp/models/user.dart';
import './firebase_methods.dart';

class FirebaseRepository {
  FireabaseMethods _fireabaseMethods = FireabaseMethods();

  Future<User?> getCurrentUser() => _fireabaseMethods.getCurrentUser();

  Future<UserCredential?> signIn() => _fireabaseMethods.signIn();

  Future<bool> authenticateUser(UserCredential credential) =>
      _fireabaseMethods.authenticateUser(credential);

  Future<void> addDataToDb(UserCredential credential) =>
      _fireabaseMethods.addDataToDb(credential);

  Future<void> signOut() => _fireabaseMethods.signOut();

  Future<List<Users>> fetchAllUsers() => _fireabaseMethods.fetchAllUsers();

  Future<void> addMessageTodb(Message message) =>
      _fireabaseMethods.addMessageToDb(message);

  void uploadImage(File image, String receiverId, senderId) =>
      _fireabaseMethods.uploadImageToStorage(image, receiverId, senderId);
}
