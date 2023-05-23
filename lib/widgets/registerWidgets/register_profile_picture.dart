import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_register_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_register_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:image_picker/image_picker.dart';

class RegisterInputsProfilePicture extends StatefulWidget {
  const RegisterInputsProfilePicture({super.key});

  @override
  State<RegisterInputsProfilePicture> createState() =>
      _RegisterInputsProfilePictureState();
}

class _RegisterInputsProfilePictureState
    extends State<RegisterInputsProfilePicture> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? user;

  final myRegBox = Hive.box("myRegistrationBox");
  late String studentNumber = myRegBox.get("studentNumber");
  late String name = myRegBox.get("name");
  late String course = myRegBox.get("course");
  late String email = myRegBox.get("email");
  late String phoneNumber = myRegBox.get("phoneNumber");
  late String password = myRegBox.get("password");
  late String hkType = myRegBox.get("hkType");
  late String hours = myRegBox.get("hours");
  late String status = myRegBox.get("status");
  late String totalHoursInDisplay = myRegBox.get("totalHoursInDisplay");
  late String totalHoursInDuration = myRegBox.get("totalHoursInDuration");
  late String totalHoursRequired = myRegBox.get("totalHoursRequired");
  late String isFinished = myRegBox.get("isFinished");
  late String onSiteDay1 = myRegBox.get("onSiteDay1");
  late String onSiteDay2 = myRegBox.get("onSiteDay2");
  late String vacantTimeDay1 = myRegBox.get("vacantTimeDay1");
  late String vacantTimeDay2 = myRegBox.get("vacantTimeDay2");
  late String wholeDayVacantTime = myRegBox.get("wholeDayVacantTime");
  late String scholarType = myRegBox.get("scholarType");
  late String town = myRegBox.get("town");

  File? image;
  String? path;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Text(
                  "Add your Profile Picture!",
                  style: TextStyle(
                    color: ColorPalette.primary,
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 1,
                color: ColorPalette.primary,
              )
            ],
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Make sure to follow these steps!",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primary,
                  ),
                ),
                Text(
                  "- Preferably a white background ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "- Wear your uniform ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "- Make sure to have a clear nice front view shot",
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "- Don't forget to smile",
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 375,
            decoration: BoxDecoration(
              color: ColorPalette.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 225,
                  height: 225,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipOval(
                      child: image == null
                          ? FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/loading.gif',
                              image: HKSAStrings.pfpPlaceholder)
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    PickedFile? results = await ImagePicker.platform.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                      maxHeight: 800,
                      maxWidth: 800,
                    );

                    if (results == null) {
                      return;
                    }

                    final pathForImage = results.path;
                    path = results.path;
                    fileName = results.path.split('/').last;

                    setState(() {
                      image = File(pathForImage);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorPalette.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Gallery",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: const [
                Text(
                  "Important Note: ",
                  style: TextStyle(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "You can only change your profile picture only this time. Please put your actual photo for your identification.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                if (image == null || fileName == null) {
                  DialogUnsuccessful(
                    headertext: "Please enter an image!",
                    subtext:
                        "We need your profile picture, for your identification.",
                    textButton: "Close",
                    callback: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ).buildUnsuccessfulScreen(context);
                  return;
                }

                DialogRegisterConfirm(
                  studentNumber,
                  name,
                  course,
                  email,
                  phoneNumber,
                  password,
                  hkType,
                  hours,
                  status,
                  totalHoursInDisplay,
                  totalHoursInDuration,
                  totalHoursRequired,
                  isFinished,
                  onSiteDay1,
                  onSiteDay2,
                  vacantTimeDay1,
                  vacantTimeDay2,
                  wholeDayVacantTime,
                  scholarType,
                  town,
                  image!,
                  () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogLoading(subtext: "Creating...")
                        .buildLoadingScreen(context);
                    await createUser(email: email, password: password).then(
                      (value) async {
                        await Storage()
                            .createScholar(
                          path!,
                          fileName,
                          studentNumber,
                          name,
                          course,
                          email,
                          phoneNumber,
                          password,
                          hkType,
                          hours,
                          status,
                          totalHoursInDisplay,
                          totalHoursInDuration,
                          totalHoursRequired,
                          isFinished,
                          onSiteDay1,
                          onSiteDay2,
                          vacantTimeDay1,
                          vacantTimeDay2,
                          wholeDayVacantTime,
                          scholarType,
                          town,
                          user!.uid,
                        )
                            .then(
                          (value) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogRegisterSuccess(
                              headertext: "Successfully Registered!",
                              subtext:
                                  "You are now registered!\nWe recommend you to log in",
                              textButton: "Log in",
                              callback: () {
                                goBackToLogin();
                              },
                            ).buildRegisterSuccessScreen(context);
                          },
                        );
                      },
                    ).catchError((e) {
                      Navigator.of(context, rootNavigator: true).pop();
                      DialogUnsuccessful(
                        headertext: "Error",
                        subtext: e.toString(),
                        textButton: "Close",
                        callback: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ).buildUnsuccessfulScreen(context);
                    });
                  },
                ).build(context);
              },
              child: const Text(
                "Next",
              ),
            ),
          )
        ],
      ),
    );
  }

  Future createUser({required String email, required String password}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => user = value.user);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  void goBackToLogin() {
    // Will replace literally every page, that includes dialogs and others.
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false);
  }
}
