import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/chat.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/widgets/scholarWidgets/messages/chat_box.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // For Searching
  String searchname = "";
  String searchid = "";

  // For Firebase
  DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  DatabaseReference _headReference =
      FirebaseDatabase.instance.ref().child("Users/Head/");

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: ColorPalette.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchname = value;
                        searchid = value;
                      });
                    },
                    controller: controller,
                    maxLength: 20,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: ColorPalette.accentDarkWhite,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              /* For the admin soon.
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  //announcements supposed to be here!
                },
                child: const Icon(
                  Icons.campaign,
                  color: ColorPalette.primary,
                  size: 40.0,
                ),
              )
              */
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contacts",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Frank Ruhl Libre',
                  fontSize: 20,
                ),
              ),
              Container(height: 1, color: ColorPalette.accentWhite)
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: getScholarsAndHead(),
              builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: ColorPalette.primary,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Loading..."),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.warning_rounded,
                          size: 200,
                          color: ColorPalette.errorColor,
                        ),
                        Text(
                          'Something went wrong!',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: ColorPalette.accentBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Please try again later.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: ColorPalette.accentBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data![index].name
                            .toLowerCase()
                            .contains(searchname.toLowerCase()) ||
                        snapshot.data![index].userId
                            .toLowerCase()
                            .contains(searchid.toLowerCase())) {
                      return ChatBox(
                        name: snapshot.data![index].name,
                        userId: snapshot.data![index].userId,
                        pfpUrl: snapshot.data![index].pfp,
                        userType: snapshot.data![index].userType,
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Chat>> getScholarsAndHead() async {
    List<Chat> myAppList = [];
    try {
      await _headReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Head myHeadObj = Head.fromJson(myObj);
            Chat myChatObj = Chat(
              name: myHeadObj.name,
              userId: myHeadObj.userId,
              pfp: myHeadObj.profilePicture,
              userType: "head",
            );
            myAppList.add(myChatObj);
          }
        },
      );
      await _profReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            Chat myChatObj = Chat(
                name: myScholarObj.name,
                userId: myScholarObj.studentNumber,
                pfp: myScholarObj.profilePicture,
                userType: "scholar");
            myAppList.add(myChatObj);
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }
}
