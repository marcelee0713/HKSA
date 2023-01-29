import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class ChatBox extends StatelessWidget {
  final String name;
  final String userId;
  const ChatBox({super.key, required this.name, required this.userId});

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
              const Icon(
                Icons.account_circle,
                size: 40,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    userId,
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
