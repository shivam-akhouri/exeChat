import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  FieldValue timestamp;
  String? photoUrl;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp});

  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp,
      required this.photoUrl});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receierId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message(
      senderId: map['senderId'],
      receiverId: map['receierId'],
      type: map['type'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
    return _message;
  }
}
