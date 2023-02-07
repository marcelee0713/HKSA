import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/universal/message_box.dart';
import 'package:intl/intl.dart';

final _inputControllerMessage = TextEditingController();
final _formKey = GlobalKey<FormState>();

class Inbox extends StatefulWidget {
  final String receiverID;
  final String receiverFullName;
  final String receiverType;
  const Inbox({
    super.key,
    required this.receiverID,
    required this.receiverFullName,
    required this.receiverType,
  });

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  // Create firestore collection for the sender and receiver
  // BUT ONLY CREATE WHEN THERE IS NO COLLECTION
  final _scrollController = ScrollController();
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  late var receiverUserType = widget.receiverType == "head"
      ? widget.receiverType
      : "${widget.receiverType}s";

  @override
  void initState() {
    super.initState();
    if (userType == "scholar" || userType == "professor") {
      userType = "${userType}s";
    }
    checkInbox();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference inboxReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userType)
        .collection(userID)
        .doc("inbox")
        .collection(widget.receiverID);
    // TO-DO
    // Both user should have firestore collection inbox
    // Create them immediately or only create them when they send a message
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.accentWhite,
      appBar: AppBar(
        backgroundColor: ColorPalette.secondary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.receiverFullName,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: ColorPalette.accentBlack,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.receiverID,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: ColorPalette.accentBlack,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(userType)
                        .collection(userID)
                        .doc("inbox")
                        .collection(widget.receiverID)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: ColorPalette.secondary,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text("Loading...",
                                  style:
                                      TextStyle(color: ColorPalette.secondary)),
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
                                size: 150,
                                color: ColorPalette.secondary,
                              ),
                              Text(
                                "Something went wrong...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: ColorPalette.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Please try again later!',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: ColorPalette.secondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.message_rounded,
                                size: 150,
                                color: ColorPalette.secondary,
                              ),
                              Text(
                                "Both of you haven't talked to each other yet?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: ColorPalette.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'I-chat mo naman.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: ColorPalette.secondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      scrollToBottom();
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return MessageBox(
                              message: snapshot.data!.docs[index]['message'],
                              date: snapshot.data!.docs[index]['date'],
                              sender: snapshot.data!.docs[index]['sender']);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              autofocus: true,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: _inputControllerMessage,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(height: 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: ColorPalette.accentDarkWhite,
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                hintText: "Send message...",
                                contentPadding: const EdgeInsets.only(
                                    left: 8.0, bottom: 8.0, top: 8.0),
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.primary,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              String input =
                                  _inputControllerMessage.text.trim();
                              if (input.isEmpty) {
                                return;
                              }
                              debugPrint(input);
                              setState(() {
                                sendMessage(message: input)
                                    .whenComplete(() => {scrollToBottom()});
                              });
                              // Scrolldown
                              _inputControllerMessage.text = "";
                            },
                            child: const Text(
                              "Send",
                              style: TextStyle(
                                color: ColorPalette.accentWhite,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future checkInbox() async {
    var inboxOfReceiver = FirebaseFirestore.instance
        .collection("users")
        .doc(userType)
        .collection(userID);

    var querySnapshot = await inboxOfReceiver.get();
    if (querySnapshot.docs.isEmpty) {
      Map<String, Object> dummyMap = {};
      final dummyHashMap = FirebaseFirestore.instance
          .collection('users')
          .doc(userType)
          .collection(userID)
          .doc("inbox");

      // this will send to THE RECEIVER'S INBOX
      final createInboxToReceiever = FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUserType)
          .collection(widget.receiverID)
          .doc("inbox");

      createInboxToReceiever.set(dummyMap);

      dummyHashMap.set(dummyMap);
    }
  }

  Future sendMessage({required String message}) async {
    // ALSO MAKE AN INBOX OF THIS USER TO THE RECEIVER
    // For this user storage

    debugPrint(receiverUserType);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("hh:mm aaaaa yyyy-MM-dd").format(now);

    // This will send to THIS USER'S INBOX
    final sendMessage = FirebaseFirestore.instance
        .collection('users')
        .doc(userType)
        .collection(userID)
        .doc("inbox")
        .collection(widget.receiverID)
        .doc(Timestamp.now().seconds.toString());

    final sendInboxToReceiver = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserType)
        .collection(widget.receiverID)
        .doc("inbox")
        .collection(userID)
        .doc(Timestamp.now().seconds.toString());

    final json = {'message': message, 'date': formattedDate, 'sender': userID};

    // SET THIS USER
    await sendMessage.set(json);

    // SET THIS RECEIVER
    await sendInboxToReceiver.set(json);
  }

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
