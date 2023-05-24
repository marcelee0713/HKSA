import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm_switch.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:hksa/widgets/universal/view_history_logs.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';

class HeadProfile extends StatefulWidget {
  final String userID;
  const HeadProfile({
    super.key,
    required this.userID,
  });

  @override
  State<HeadProfile> createState() => _HeadProfileState();
}

class _HeadProfileState extends State<HeadProfile> {
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Container(
        padding: const EdgeInsets.all(20),
        color: ColorPalette.accentWhite,
        child: FutureBuilder(
          future: getHead(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SpinKitCircle(
                      color: ColorPalette.secondary,
                      size: 100,
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

            String phoneVerified =
                snapshot.data!.first.isPhoneVerified == "true"
                    ? "Phone number is verified"
                    : "Phone number is not verified";
            String emailVerified =
                snapshot.data!.first.isEmailVerified == "true"
                    ? "Email is verified"
                    : "Email is not verified";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/loading.gif',
                              image: snapshot.data!.first.profilePicture),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                message:
                                    snapshot.data!.first.isSuperAdmin == "true"
                                        ? "Super Admin"
                                        : "Admin",
                                preferBelow: false,
                                waitDuration: const Duration(milliseconds: 500),
                                height: 20,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentWhite,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary.withOpacity(0.85),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Icon(Icons.support_agent_rounded),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  snapshot.data!.first.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                message: phoneVerified,
                                preferBelow: false,
                                waitDuration: const Duration(milliseconds: 500),
                                height: 20,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentWhite,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary.withOpacity(0.85),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Icon(Icons.phone),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                snapshot.data!.first.phonenumber,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                message: emailVerified,
                                preferBelow: false,
                                waitDuration: const Duration(milliseconds: 500),
                                height: 20,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentWhite,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary.withOpacity(0.85),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Icon(Icons.email_rounded),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  snapshot.data!.first.email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                message: "Status",
                                preferBelow: false,
                                waitDuration: const Duration(milliseconds: 500),
                                height: 20,
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentWhite,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary.withOpacity(0.85),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Icon(Icons.info),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  snapshot.data!.first.status.replaceAll(
                                      snapshot.data!.first.status
                                          .substring(0, 1),
                                      snapshot.data!.first.status
                                          .substring(0, 1)
                                          .toUpperCase()),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "If you have any concerns, feel free to message me!",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                isSuperAdmin
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Options",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                color: ColorPalette.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Inbox(
                                          receiverFullName:
                                              snapshot.data!.first.name,
                                          receiverID:
                                              snapshot.data!.first.userId,
                                          receiverType: "head",
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.primary,
                                  ),
                                  child: const Text(
                                    "Message",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorPalette.accentWhite),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HistoryLogs(userID: widget.userID),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.primary,
                                  ),
                                  child: const Text(
                                    "View History Logs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorPalette.accentWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    DialogConfirm(
                                      headertext:
                                          "User status will be active now, you sure?",
                                      callback: () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        DialogLoading(subtext: "Loading...")
                                            .buildLoadingScreen(context);
                                        final DatabaseReference
                                            statusReference =
                                            FirebaseDatabase.instance.ref().child(
                                                'Users/Head/${widget.userID}/status');

                                        await statusReference
                                            .set("active")
                                            .then((value) async {
                                          setState(() {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            DialogSuccess(
                                              headertext: "Success",
                                              subtext:
                                                  "They can now log in and make changes in the app",
                                              textButton: "Close",
                                              callback: () => Navigator.of(
                                                      context,
                                                      rootNavigator: true)
                                                  .pop(),
                                            ).buildSuccessScreen(context);
                                          });

                                          await createHistory(
                                            desc:
                                                "Made a Head Active: ${snapshot.data!.first.name}(${snapshot.data!.first.userId})",
                                            timeStamp: DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString(),
                                            userType: userType,
                                            id: userID,
                                          );
                                        }).catchError((e) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogUnsuccessful(
                                            headertext: "Error",
                                            subtext: "Please try again later!",
                                            textButton: "Close",
                                            callback: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ).buildUnsuccessfulScreen(context);
                                        });
                                      },
                                    ).buildConfirmScreen(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.primary,
                                  ),
                                  child: const Text(
                                    "Reactivate",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorPalette.accentWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Danger Zone",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                color: ColorPalette.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    DialogConfirmSwitch(
                                      headertext: "Switching Roles",
                                      subtext:
                                          "Make sure both of you talked about this. You will be an Admin, and this user will become a Super Admin.",
                                      callback: () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();

                                        DatabaseReference headRef =
                                            FirebaseDatabase.instance
                                                .ref()
                                                .child("Users/Head/");

                                        await headRef
                                            .child(
                                                "${widget.userID}/isSuperAdmin")
                                            .set("true")
                                            .then(
                                          (value) async {
                                            await headRef
                                                .child("$userID/isSuperAdmin")
                                                .set("false")
                                                .then(
                                              (value) async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                setState(() {
                                                  isSuperAdmin = false;
                                                });

                                                DialogSuccess(
                                                    headertext: "Switched!",
                                                    subtext:
                                                        "You are now an admin!",
                                                    textButton: "Close",
                                                    callback: () => Navigator
                                                            .of(context,
                                                                rootNavigator:
                                                                    true)
                                                        .pop()).buildSuccessScreen(
                                                    context);

                                                await createHistory(
                                                    desc:
                                                        "$userID switched roles to ${widget.userID}.",
                                                    timeStamp: DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString(),
                                                    userType: userType,
                                                    id: userID);
                                              },
                                            ).catchError((e) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              DialogUnsuccessful(
                                                headertext: "Error",
                                                subtext:
                                                    "Failed to set you to become an Admin!",
                                                textButton: "Close",
                                                callback: () => Navigator.of(
                                                        context,
                                                        rootNavigator: true)
                                                    .pop(),
                                              ).buildUnsuccessfulScreen(
                                                  context);
                                            });
                                          },
                                        ).catchError(
                                          (e) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            DialogUnsuccessful(
                                              headertext: "Error",
                                              subtext:
                                                  "Please try again later!",
                                              textButton: "Close",
                                              callback: () => Navigator.of(
                                                      context,
                                                      rootNavigator: true)
                                                  .pop(),
                                            ).buildUnsuccessfulScreen(context);
                                          },
                                        );
                                      },
                                    ).buildConfirmSwitchScreen(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.errorColor,
                                  ),
                                  child: const Text(
                                    "Switch Roles",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorPalette.accentWhite),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    DialogConfirm(
                                        headertext:
                                            "Are you sure you want to reset the history logs of this user?",
                                        callback: () async {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();

                                          DialogLoading(subtext: "Resetting...")
                                              .buildLoadingScreen(context);

                                          final DatabaseReference
                                              historyLogsReference =
                                              FirebaseDatabase.instance.ref().child(
                                                  'historylogs/${widget.userID}');

                                          await historyLogsReference
                                              .remove()
                                              .then(
                                            (value) async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

                                              DialogSuccess(
                                                headertext: "Success",
                                                subtext:
                                                    "You have successfully reset the History Logs of this user! ",
                                                textButton: "Close",
                                                callback: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ).buildSuccessScreen(context);

                                              await createHistory(
                                                desc:
                                                    "Reset the History Logs of the Head: ${snapshot.data!.first.name}(${snapshot.data!.first.userId})",
                                                timeStamp: DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString(),
                                                userType: userType,
                                                id: userID,
                                              );
                                            },
                                          ).catchError(
                                            (err) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

                                              DialogUnsuccessful(
                                                headertext: "Error",
                                                subtext:
                                                    "Please try again later!",
                                                textButton: "Close",
                                                callback: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ).buildUnsuccessfulScreen(
                                                  context);
                                            },
                                          );
                                        }).buildConfirmScreen(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.errorColor,
                                  ),
                                  child: const Text(
                                    "Reset History Logs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorPalette.accentWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              DialogConfirm(
                                headertext:
                                    "User will log out and can't log in. You sure?",
                                callback: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogLoading(subtext: "Loading...")
                                      .buildLoadingScreen(context);
                                  final DatabaseReference statusReference =
                                      FirebaseDatabase.instance.ref().child(
                                          'Users/Head/${widget.userID}/status');

                                  await statusReference
                                      .set("inactive")
                                      .then((value) async {
                                    setState(() {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      DialogSuccess(
                                        headertext: "Success",
                                        subtext:
                                            "Again, it will log them out. If you wanna know when they logged out, go to its history logs.",
                                        textButton: "Close",
                                        callback: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                      ).buildSuccessScreen(context);
                                    });

                                    await createHistory(
                                      desc:
                                          "Made a Head Inactive: ${snapshot.data!.first.name}(${snapshot.data!.first.userId})",
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      userType: userType,
                                      id: userID,
                                    );
                                  }).catchError((e) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Error",
                                      subtext: "Please try again later!",
                                      textButton: "Close",
                                      callback: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    ).buildUnsuccessfulScreen(context);
                                  });
                                },
                              ).buildConfirmScreen(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.errorColor,
                            ),
                            child: const Text(
                              "Deactivate",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: ColorPalette.accentWhite),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Inbox(
                                receiverFullName: snapshot.data!.first.name,
                                receiverID: snapshot.data!.first.userId,
                                receiverType: "head",
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primary,
                        ),
                        child: const Text(
                          "Message",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.accentWhite),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Head>> getHead() async {
    List<Head> myUser = [];
    final DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('Users/Head/${widget.userID}');
    try {
      await userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Head myHead = Head.fromJson(myObj);

        myUser.add(myHead);
      });
      return myUser;
    } catch (error) {
      throw error.toString();
    }
  }
}
