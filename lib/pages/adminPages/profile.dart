import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:hksa/widgets/universal/change_password.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final Storage storage = Storage();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");

  String userProfileListener = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      drawer: const NavDraw(),
      body: Container(
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
                      size: 100,
                      color: ColorPalette.secondary,
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
            String emailVerified =
                snapshot.data!.first.isEmailVerified == "true"
                    ? "Your email is verified"
                    : "Your email is not verified";
            String phoneVerified =
                snapshot.data!.first.isPhoneVerified == "true"
                    ? "Your phone number is verified"
                    : "Your phone number is not verified";
            return Stack(
              children: [
                Builder(builder: (context) {
                  return SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu_rounded,
                          size: 40,
                          color: ColorPalette.primary,
                        ),
                      ),
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
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
                                    image: userProfileListener),
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
                                          snapshot.data!.first.isSuperAdmin ==
                                                  "true"
                                              ? "Super Admin"
                                              : "Admin",
                                      preferBelow: false,
                                      waitDuration:
                                          const Duration(milliseconds: 500),
                                      height: 20,
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        color: ColorPalette.accentWhite,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primary
                                            .withOpacity(0.85),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: const Icon(
                                          Icons.support_agent_rounded),
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
                                      waitDuration:
                                          const Duration(milliseconds: 500),
                                      height: 20,
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        color: ColorPalette.accentWhite,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primary
                                            .withOpacity(0.85),
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
                                      waitDuration:
                                          const Duration(milliseconds: 500),
                                      height: 20,
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        color: ColorPalette.accentWhite,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primary
                                            .withOpacity(0.85),
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
                                      message: "User ID",
                                      preferBelow: false,
                                      waitDuration:
                                          const Duration(milliseconds: 500),
                                      height: 20,
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        color: ColorPalette.accentWhite,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primary
                                            .withOpacity(0.85),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: const Icon(Icons.badge_rounded),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.first.userId,
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
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome to your Profile!",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Well, here is the only thing you can do pretty much here.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        color: ColorPalette.accentBlack,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          PickedFile? results =
                              await ImagePicker.platform.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                            maxHeight: 800,
                            maxWidth: 800,
                          );

                          if (results == null) {
                            return;
                          }

                          // ignore: use_build_context_synchronously
                          DialogLoading(subtext: "Changing...")
                              .buildLoadingScreen(context);

                          final path = results.path;
                          final fileName = results.path.split('/').last;

                          await storage.changeHeadPfp(
                            path,
                            fileName,
                            userID,
                            snapshot.data!.first.profilePicture,
                            () {
                              Future.delayed(
                                const Duration(seconds: 3),
                                () async {
                                  setState(() {
                                    userProfileListener =
                                        snapshot.data!.first.profilePicture;
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogSuccess(
                                    headertext: "Profile Picture Changed!",
                                    subtext:
                                        "Didn't showed? Restart or go to a different page and comeback!",
                                    textButton: "Close",
                                    callback: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ).buildSuccessScreen(context);
                                  await createHistory(
                                    desc: "Changed the profile picture.",
                                    timeStamp: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    userType: userType,
                                    id: userID,
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Change Profile Picture",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(
                                  userID: userID, userType: "Head"),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          DialogLoading(subtext: "Changing...")
                              .buildLoadingScreen(context);
                          if (result == null) {
                            return;
                          }

                          await changePassword(newPassword: result).then(
                            (value) async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogSuccess(
                                headertext: "Successfully changed!",
                                subtext:
                                    "You successfully changed your password! Remember not to show this to anyone.",
                                textButton: "Close",
                                callback: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ).buildSuccessScreen(context);
                              await createHistory(
                                desc: "Changed password",
                                timeStamp: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                userType: userType,
                                id: userID,
                              );
                            },
                          ).catchError(
                            (err) {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogUnsuccessful(
                                headertext: "Error",
                                subtext: err,
                                textButton: "Close",
                                callback: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                              ).buildUnsuccessfulScreen(context);
                            },
                          );
                        },
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future changePassword({required String newPassword}) async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw "Error, we recommend you to log in again.";
      }
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<List<Head>> getHead() async {
    List<Head> myUser = [];
    final DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('Users/Head/$userID');
    try {
      await userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Head myHead = Head.fromJson(myObj);
        userProfileListener = myHead.profilePicture;
        myUser.add(myHead);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
