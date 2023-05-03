import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:hksa/widgets/universal/change_password.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final Storage storage = Storage();
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  String userProfileListener = "";
  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("Users/Head/$userID/password");
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data!.first.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              snapshot.data!.first.userId,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

                          await storage.changeHeadPfp(path, fileName, userID,
                              snapshot.data!.first.profilePicture, () {
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                userProfileListener =
                                    snapshot.data!.first.profilePicture;
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogSuccess(
                                  headertext: "Profile Picture Changed!",
                                  subtext:
                                      "Didn't showed? Restart or go to a different page and comeback!",
                                  textButton: "Close",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  }).buildSuccessScreen(context);
                            });
                          });
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
                          if (result == null) {
                            return;
                          }
                          await dbReference.set(result.toString());

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }).whenComplete(() {
                            DialogSuccess(
                                headertext: "Successfully changed!",
                                subtext:
                                    "You successfully changed your password! Remember not to show this to anyone.",
                                textButton: "Close",
                                callback: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }).buildSuccessScreen(context);
                          });
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

  Future<List<Head>> getHead() async {
    List<Head> myUser = [];
    final DatabaseReference _userReference =
        FirebaseDatabase.instance.ref().child('Users/Head/$userID');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Head myScholar = Head.fromJson(myObj);
        userProfileListener = myScholar.profilePicture;
        myUser.add(myScholar);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
