import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/widgets/universal/view_head.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';
import 'package:hksa/widgets/universal/view_professor.dart';
import 'package:hksa/widgets/universal/view_scholar.dart';

class ChatBox extends StatefulWidget {
  final String name;
  final String userId;
  final String pfpUrl;
  final String userType;
  final String isIncomplete;
  const ChatBox(
      {super.key,
      required this.name,
      required this.userId,
      required this.pfpUrl,
      required this.userType,
      required this.isIncomplete});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.userType == "professor") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfessorProfile(userID: widget.userId)));
        } else if (widget.userType == "head") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HeadProfile(userID: widget.userId)));
        } else if (widget.userType == "scholar") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScholarProfile(userID: widget.userId)));
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.accentDarkWhite,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/loading.gif',
                              image: widget.pfpUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.name,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorPalette.accentBlack,
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        widget.userType == "head"
                            ? Container()
                            : Text(
                                widget.userId,
                                style: const TextStyle(
                                  color: ColorPalette.accentBlack,
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                        widget.isIncomplete == "true"
                            ? const Text(
                                "INC",
                                style: TextStyle(
                                  color: ColorPalette.errorColor,
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // Basically it will take the full name and user ID of the user
                    // he wants to chat.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Inbox(
                                  receiverFullName: widget.name,
                                  receiverID: widget.userId,
                                  receiverType: widget.userType,
                                )));
                  },
                  child: const Icon(
                    Icons.chat_bubble,
                    color: ColorPalette.primary,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userType == "head" ? userType : "${userType}s")
                .collection(userID)
                .doc("inbox")
                .collection(widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                debugPrint("${userType}");
                debugPrint("${userID}");
                debugPrint("${widget.userId}");

                return const SizedBox();
              }
              int howMany = 0;

              if (snapshot.data!.docs.isNotEmpty) {
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> data = doc.data();
                  String sender = data['sender'] ?? '';
                  String hasRead = data['read'] ?? '';

                  if (sender == widget.userId) {
                    if (hasRead == "false") {
                      howMany++;
                    }
                  }
                }
              } else {
                howMany = 0;
              }

              return howMany == 0
                  ? const SizedBox()
                  : Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: ColorPalette.errorColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            howMany > 99 ? "+99" : howMany.toString(),
                            style: const TextStyle(
                                color: ColorPalette.accentWhite,
                                fontFamily: 'Inter',
                                fontSize: 8.5),
                          ),
                        ),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
