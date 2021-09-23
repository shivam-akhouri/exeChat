import 'package:flutter/material.dart';
import 'package:videochatapp/models/user.dart';
import 'package:videochatapp/resources/firebase_methods.dart';
import 'package:videochatapp/resources/firebase_repository.dart';
import 'package:videochatapp/screens/chat/chat_screen.dart';
import 'package:videochatapp/utils/universal_variables.dart';
import 'package:videochatapp/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);
  static String routeName = "/search-page";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<Users> userList = [];
  String query = "";
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.fetchAllUsers().then((List<Users> list) {
      setState(() {
        userList = list;
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_left),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      title: TextField(
        decoration: InputDecoration(hintText: "Search"),
        controller: searchController,
        onChanged: (val) {
          setState(() {
            query = val;
          });
        },
        onSubmitted: (val) {
          print(val);
          WidgetsBinding.instance!
              .addPostFrameCallback((_) => searchController.clear());
        },
        cursorColor: UniversalVariables.blackColor,
        autofocus: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 35.0,
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<Users> suggestionList = query.isEmpty
        ? []
        : userList.where((element) {
            return element.name!.toLowerCase().contains(query.toLowerCase());
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Users searchedUser = Users(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );
        return CustomTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto as String),
            backgroundColor: UniversalVariables.greyColor,
          ),
          title: Text(
            searchedUser.name as String,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
          subtitle: Text(searchedUser.name as String),
          mini: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiver: searchedUser,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      // appBar: searchAppBar(context),
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: buildSuggestions(query),
      ),
    );
  }
}
