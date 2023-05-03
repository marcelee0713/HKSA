import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';

class MessageBox extends StatefulWidget {
  final String message;
  final String date;
  final String sender;
  const MessageBox(
      {super.key,
      required this.message,
      required this.date,
      required this.sender});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.sender == userID
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 40,
          minWidth: 40,
          maxWidth: 250,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: widget.sender == userID
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.sender == userID
                      ? ColorPalette.accentDarkWhite
                      : ColorPalette.secondary,
                ),
                child: Column(
                  children: [
                    SelectableText(
                      widget.message,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Text(
                widget.date,
                style: const TextStyle(
                    color: Color.fromARGB(255, 172, 172, 172),
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
