import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:videochatapp/models/message.dart';
import 'package:videochatapp/providers/signInProvider.dart';
import '../models/user.dart';

class FireabaseMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<User?> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<UserCredential?> signIn() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    if (googleAuth == null) {
      return null;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> authenticateUser(UserCredential credential) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: credential.user!.email)
        .get();

    final docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential credential) async {
    Users user = new Users(
      uid: credential.user!.uid,
      email: credential.user!.email,
      name: credential.user!.displayName,
      profilePhoto: credential.user!.photoURL,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(user.toMap(user));
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<Users>> fetchAllUsers() async {
    List<Users> userList = <Users>[];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].get("uid") ==
          FirebaseAuth.instance.currentUser!.uid) {
        continue;
      }
      print(querySnapshot.docs[i].get('name'));
      userList.add(Users(
          name: querySnapshot.docs[i].get('name'),
          uid: querySnapshot.docs[i].get('uid'),
          email: querySnapshot.docs[i].get('email'),
          state: querySnapshot.docs[i].get('state'),
          status: querySnapshot.docs[i].get('status'),
          profilePhoto: querySnapshot.docs[i].get('profile_photo'),
          username: querySnapshot.docs[i].get('username')));
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message) async {
    var map = message.toMap();
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<void> addImageMessageToDb(Message message) async {
    var map = message.toImageMap();
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  uploadImageToStorage(File image, String receiverId, String senderId) {
    // Adding image to the database
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('chat-storage')
        .child(
            '${FirebaseAuth.instance.currentUser!.uid}-${DateTime.now().microsecondsSinceEpoch}');
    UploadTask uploadFile = reference.putFile(image);
    uploadFile.whenComplete(() async {
      try {
        String imageUrl = await reference.getDownloadURL();
        Message _message;
        _message = Message.imageMessage(
            senderId: senderId,
            receiverId: receiverId,
            type: 'image',
            message: "image",
            timestamp: Timestamp.now(),
            photoUrl: imageUrl);
        await addImageMessageToDb(_message);
      } catch (e) {
        print(e);
      }
    });
  }
}
