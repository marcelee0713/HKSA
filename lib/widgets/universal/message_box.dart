import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';

class MessageBox extends StatefulWidget {
  final String message;
  final String date;
  final String sender;
  final String seen;
  const MessageBox(
      {super.key,
      required this.message,
      required this.date,
      required this.sender,
      required this.seen});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
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
                      crossAxisAlignment: widget.sender == userID
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          widget.message,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.date,
                          style: TextStyle(
                              color: widget.sender == userID
                                  ? const Color.fromARGB(255, 124, 124, 124)
                                  : const Color.fromARGB(255, 71, 71, 71),
                              fontFamily: 'Inter',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.sender == userID)
          widget.seen == "true"
              ? const Positioned(
                  bottom: 5,
                  right: -2,
                  child: Tooltip(
                    message: "Seen",
                    preferBelow: false,
                    triggerMode: TooltipTriggerMode.tap,
                    textStyle: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Icon(
                      Icons.done_all_rounded,
                      size: 15,
                      color: ColorPalette.primary,
                    ),
                  ),
                )
              : const Positioned(
                  bottom: 5,
                  right: -2,
                  child: Tooltip(
                    message: "Delivered",
                    preferBelow: false,
                    triggerMode: TooltipTriggerMode.tap,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    textStyle: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                    child: Icon(
                      Icons.done_rounded,
                      size: 15,
                      color: ColorPalette.primary,
                    ),
                  ),
                ),
      ],
    );
  }
}
