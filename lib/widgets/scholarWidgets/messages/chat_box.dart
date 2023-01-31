import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class ChatBox extends StatefulWidget {
  final String name;
  final String userId;
  final String pfpUrl;
  const ChatBox(
      {super.key,
      required this.name,
      required this.userId,
      required this.pfpUrl});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(
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
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
