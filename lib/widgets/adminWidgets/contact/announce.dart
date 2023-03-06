import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class Announce extends StatefulWidget {
  const Announce({super.key});

  @override
  State<Announce> createState() => _AnnounceState();
}

class _AnnounceState extends State<Announce> {
  final _inputController = TextEditingController();
  // For Firebase
  final DatabaseReference _scholarReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  final DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");

  final logInBox = Hive.box("myLoginBox");

  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: ColorPalette.accentWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Announcement",
                      style: TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "This will send to all Scholars and Professors",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    controller: _inputController,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "Enter an input.";
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: ColorPalette.accentDarkWhite,
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                        hintText: "Post an announcement!",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10)),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorPalette.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      // We make inbox for all the Scholars and Professors
                      // And also admin should have inboxes of all of the user
                      // That he sents
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      DialogConfirm(
                          headertext:
                              "Are you sure you want to post this announcement?",
                          callback: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogLoading(subtext: "Sending...")
                                .buildLoadingScreen(context);

                            Future.delayed(const Duration(seconds: 2), () {
                              _scholarReference.get().then((snapshot) {
                                for (final scholarsId in snapshot.children) {
                                  String scholarID = scholarsId.key.toString();
                                  String recieverUserType = "scholars";
                                  checkInbox(recieverUserType, scholarID);
                                  sendMessage(
                                      message: _inputController.text.trim(),
                                      receiverID: scholarID,
                                      receiverUserType: recieverUserType);
                                }
                              }).whenComplete(() {
                                _profReference.get().then((snapshot) {
                                  for (final professorsId
                                      in snapshot.children) {
                                    String professorID =
                                        professorsId.key.toString();
                                    String recieverUserType = "professors";
                                    checkInbox(recieverUserType, professorID);
                                    sendMessage(
                                        message: _inputController.text.trim(),
                                        receiverID: professorID,
                                        receiverUserType: recieverUserType);
                                  }
                                });
                              });
                            }).whenComplete(() {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogSuccess(
                                  headertext: "Successfully posted!",
                                  subtext:
                                      "You have succesfully sent to all users, care to share another?",
                                  textButton: "Clear",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _inputController.text = "";
                                  }).buildSuccessScreen(context);
                            });
                          }).buildConfirmScreen(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future checkInbox(String receiverUserType, receiverID) async {
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
          .collection(receiverID)
          .doc("inbox");

      createInboxToReceiever.set(dummyMap);

      dummyHashMap.set(dummyMap);
    }
  }

  Future sendMessage(
      {required String message, receiverUserType, receiverID}) async {
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
        .collection(receiverID)
        .doc(Timestamp.now().seconds.toString());

    final sendInboxToReceiver = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserType)
        .collection(receiverID)
        .doc("inbox")
        .collection(userID)
        .doc(Timestamp.now().seconds.toString());

    final json = {'message': message, 'date': formattedDate, 'sender': userID};

    // SET THIS USER
    await sendMessage.set(json);

    // SET THIS RECEIVER
    await sendInboxToReceiver.set(json);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _inputController.dispose();
    super.dispose();
  }
}
