import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/login_screen.dart';
import 'package:videochatapp/screens/login_screen_rahul.dart';
import 'package:videochatapp/screens/search_screen.dart';
import 'package:videochatapp/utils/universal_variables.dart';
import 'package:videochatapp/widgets/appbar.dart';
import 'package:videochatapp/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreeState createState() => _ChatListScreeState();
}

final FirebaseRepository _repository = new FirebaseRepository();

class _ChatListScreeState extends State<ChatListScreen> {
  late String image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    image = FirebaseAuth.instance.currentUser!.photoURL as String;
  }

  customAppBar(BuildContext context) {
    return CustomAppBar(
        title: UserCircle(
            username: FirebaseAuth.instance.currentUser!.photoURL as String),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, SearchScreen.routeName),
              icon: Icon(Icons.search)),
        ],
        leading: IconButton(
          icon: Icon(Icons.notifications),
          color: Colors.white,
          onPressed: () async {
            await _repository.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyLoginPage()));
          },
        ),
        centerTitle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(
        currentUserId: 'Shivam',
      ),
    );
  }
}

class UserCircle extends StatelessWidget {
  const UserCircle({Key? key, required this.username}) : super(key: key);
  final username;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(username),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: UniversalVariables.blackColor),
                  color: UniversalVariables.onlineDotColor),
            ),
          )
        ],
      ),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: UniversalVariables.separatorColor),
    );
  }
}

class NewChatButton extends StatelessWidget {
  const NewChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  ChatListContainer({Key? key, required this.currentUserId}) : super(key: key);
  final String currentUserId;
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: 2,
          itemBuilder: (context, index) {
            return CustomTile(
              mini: true,
              onTap: () {},
              onLongPress: () {},
              title: Text(
                "VideoChat App",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Arial",
                  fontSize: 19,
                ),
              ),
              subtitle: Text(
                "Hi",
                style: TextStyle(
                  color: UniversalVariables.greyColor,
                  fontFamily: "Arial",
                  fontSize: 14,
                ),
              ),
              leading: Container(
                constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/originals/19/cf/78/19cf789a8e216dc898043489c16cec00.jpg"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: UniversalVariables.onlineDotColor,
                          border: Border.all(
                            color: UniversalVariables.blackColor,
                            width: 2,
                          )),
                    ),
                  ),
                ]),
                alignment: Alignment.center,
              ),
            );
          }),
    );
  }
}
