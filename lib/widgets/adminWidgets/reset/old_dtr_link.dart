import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/api/send_message.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class UploadGoogleDrivePage extends StatefulWidget {
  const UploadGoogleDrivePage({super.key});

  @override
  State<UploadGoogleDrivePage> createState() => _UploadGoogleDrivePageState();
}

class _UploadGoogleDrivePageState extends State<UploadGoogleDrivePage> {
  final formKey = GlobalKey<FormState>();
  final inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DatabaseReference testReference =
        FirebaseDatabase.instance.ref().child("olddtrlink");

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Change OLD DTR Link:",
              style: TextStyle(
                color: ColorPalette.primary,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Where Scholars can upload their OLD DTR file by the Google Drive Link you're going to either change.",
              style: TextStyle(
                color: ColorPalette.primary,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Strictly a Google Drive Link.\nBecause this will also notify all of the Scholars.",
              style: TextStyle(
                color: ColorPalette.errorColor,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: inputController,
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
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: ColorPalette.accentDarkWhite,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
              hintText: "https://drive.google.com/drive/folders/...",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ColorPalette.primary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              String link = inputController.text.trim();
              DialogConfirm(
                headertext: "Are you sure you want to change the link?",
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Changing...")
                      .buildLoadingScreen(context);
                  await testReference.set(link).catchError((error) {
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: "Please try it again later!",
                      textButton: "Close",
                      callback: () {
                        inputController.text = "";
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ).buildUnsuccessfulScreen(context);
                  }).then((value) async {
                    String res = await sendNotificationToTopic(
                      'scholars',
                      "Updated Google Drive Link",
                      "Google Drive link has now changed to a different link, please upload your OLD DTR file as soon as possible!",
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context, rootNavigator: true).pop();
                    if (res == "success") {
                      // ignore: use_build_context_synchronously
                      DialogSuccess(
                        headertext:
                            "Google Drive Link has now successfully changed/updated!",
                        subtext:
                            "And also it'll notify to Scholars! That you've changed the Google Drive Link!",
                        textButton: "Close",
                        callback: () {
                          inputController.text = "";
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ).buildSuccessScreen(context);
                    } else {
                      // ignore: use_build_context_synchronously
                      DialogUnsuccessful(
                        headertext: "Error",
                        subtext:
                            "Seems like we can't send a notification, please try again.",
                        textButton: "Close",
                        callback: () {
                          inputController.text = "";
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ).buildUnsuccessfulScreen(context);
                    }
                  });
                },
              ).buildConfirmScreen(context);
            },
            child: const Text(
              "CHANGE",
              style: TextStyle(
                color: ColorPalette.accentWhite,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
