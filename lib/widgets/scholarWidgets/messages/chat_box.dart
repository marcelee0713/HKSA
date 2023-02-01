import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/widgets/universal/view_head.dart';
import 'package:hksa/widgets/universal/view_professor.dart';
import 'package:hksa/widgets/universal/view_scholar.dart';

class ChatBox extends StatefulWidget {
  final String name;
  final String userId;
  final String pfpUrl;
  final String userType;
  const ChatBox(
      {super.key,
      required this.name,
      required this.userId,
      required this.pfpUrl,
      required this.userType});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorPalette.accentWhite,
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
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                debugPrint("HELLO CHAT AKO");
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
    );
  }
}
