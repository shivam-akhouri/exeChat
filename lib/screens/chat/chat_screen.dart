import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:videochatapp/models/message.dart';
import 'package:videochatapp/models/user.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/utils/universal_variables.dart';
import 'package:videochatapp/widgets/appbar.dart';
import 'package:videochatapp/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final Users receiver;

  ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = new TextEditingController();
  bool isWriting = false;
  late Users sender;
  FirebaseRepository _repository = new FirebaseRepository();

  @override
  void initState() {
    super.initState();
    setState(() {
      sender = Users(
        uid: FirebaseAuth.instance.currentUser!.uid,
        name: FirebaseAuth.instance.currentUser!.displayName,
        profilePhoto: FirebaseAuth.instance.currentUser!.photoURL,
      );
    });
  }

  sendMessage() {
    var text = textEditingController.text;
    Message _message = Message(
      receiverId: widget.receiver.uid as String,
      senderId: sender.uid as String,
      message: text,
      timestamp: FieldValue.serverTimestamp(),
      type: 'text',
    );

    setState(() {
      textEditingController.clear();
      isWriting = false;
    });
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
        title: Text(widget.receiver.name as String),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.phone))
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false);
  }

  chatControls() {
    setEditing(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textEditingController.text;
      Message message = Message(
          senderId: sender.uid as String,
          receiverId: widget.receiver.uid as String,
          type: 'text',
          message: text,
          timestamp: FieldValue.serverTimestamp());
      setState(() {
        isWriting = false;
      });
      _repository.addMessageTodb(message);
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (builder) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: Icon(Icons.close),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Content and tools",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                Flexible(
                    child: ListView(
                  children: [
                    ModalTile(
                      title: "Modal",
                      subtitle: "Share videos and photos",
                      iconData: Icons.image,
                    ),
                    ModalTile(
                      title: "File",
                      subtitle: "Files",
                      iconData: Icons.tab,
                    ),
                    ModalTile(
                      title: "Contact",
                      subtitle: "Share Contacts",
                      iconData: Icons.contacts,
                    ),
                    ModalTile(
                      title: "Location",
                      subtitle: "Share a location",
                      iconData: Icons.add_location,
                    ),
                    ModalTile(
                      title: "Schedule call",
                      subtitle: "Arrange reminders",
                      iconData: Icons.schedule,
                    ),
                    ModalTile(
                      title: "Polls",
                      subtitle: "Create polls",
                      iconData: Icons.poll,
                    ),
                  ],
                ))
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setEditing(true)
                    : setEditing(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: UniversalVariables.greyColor),
                border: OutlineInputBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(50.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting ? Container() : Icon(Icons.camera_alt),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, size: 15.0),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(sender.uid)
            .collection(widget.receiver.uid as String)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return chatMessageItem(snapshot.data!.docs[index]);
              });
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        alignment: snapshot['senderId'] == sender.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderId'] == sender.uid
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(top: 3.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
          color: Colors.blue.shade600,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          )),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: getMessage(
            snapshot,
          )),
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot['message'],
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(top: 3.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          )),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(snapshot),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: UniversalVariables.blackColor,
      body: Column(
        children: [
          Flexible(child: messageList()),
          chatControls(),
        ],
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  const ModalTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            iconData,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.0,
            color: UniversalVariables.greyColor,
          ),
        ),
      ),
    );
  }
}
