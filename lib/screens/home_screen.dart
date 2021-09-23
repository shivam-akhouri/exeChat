import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videochatapp/pageviews/chat_list_screen.dart';
import 'package:videochatapp/providers/signInProvider.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/login_screen.dart';
import 'package:videochatapp/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;
  int _page = 0;
  FirebaseRepository _repository = new FirebaseRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  onPageChange(int x) {
    setState(() {
      _page = x;
    });
  }

  void _navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: PageView(
          children: [
            Container(
              child: ChatListScreen(),
            ),
            // ElevatedButton(
            //     child: Text("Logout"),
            //     onPressed: () {
            //       _repository.signOut();
            //       Provider.of<SignInProvider>(context, listen: false)
            //           .setSignIn(false);
            //       Navigator.pushReplacement(context,
            //           MaterialPageRoute(builder: (context) => LoginScreen()));
            //     }),
            Center(child: Text("chat")),
            Center(child: Text("call")),
          ],
          controller: pageController,
          onPageChanged: onPageChange,
        ),
        bottomNavigationBar: Container(
          color: UniversalVariables.blackColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  backgroundColor: (_page == 0)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                  label: "Chats",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  backgroundColor: (_page == 1)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                  label: "Calls",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone),
                  backgroundColor: (_page == 2)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                  label: "Contacts",
                ),
              ],
              onTap: _navigationTap,
              currentIndex: _page,
              backgroundColor: UniversalVariables.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
