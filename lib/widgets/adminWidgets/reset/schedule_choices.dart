import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class ScheduleChoices extends StatefulWidget {
  const ScheduleChoices({super.key});

  @override
  State<ScheduleChoices> createState() => _ScheduleChoicesState();
}

class _ScheduleChoicesState extends State<ScheduleChoices> {
  final DatabaseReference choicesReference =
      FirebaseDatabase.instance.ref().child("scheduleChoices/");
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
  final formKeyForRoom = GlobalKey<FormState>();
  final formKeyForSection = GlobalKey<FormState>();
  final formKeyForSubject = GlobalKey<FormState>();

  final inputControllerForRoom = TextEditingController();
  final inputControllerForSection = TextEditingController();
  final inputControllerForSubjectCode = TextEditingController();

  String? roomValue;
  String? sectionValue;
  String? subjectValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Schedule Choices:",
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
            "Where you can put and delete the choices of Subject Codes, Sections, and Rooms.",
            style: TextStyle(
              color: ColorPalette.primary,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Important note:",
            style: TextStyle(
              color: ColorPalette.errorColor,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: const TextSpan(
              text: 'Please be careful ',
              style: TextStyle(
                color: ColorPalette.errorColor,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'REMOVING ANY CHOICES. ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      'This can create conflicts to one or more professors, if they already have a room, section, and a subject code.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: getRooms(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Fetching rooms...',
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SpinKitThreeBounce(
                    color: ColorPalette.secondary,
                    size: 15,
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning_rounded,
                    color: ColorPalette.errorColor,
                    size: 15,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Error fetching rooms.',
                    style: TextStyle(
                      color: ColorPalette.errorColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              );
            }

            return Form(
              key: formKeyForRoom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "We currently have ${snapshot.data!.length} room(s).",
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0.5),
                    decoration: const BoxDecoration(
                      color: ColorPalette.accentDarkWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          snapshot.data!.isNotEmpty
                              ? "Rooms"
                              : "No Rooms Currently",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        isExpanded: true,
                        iconSize: 32,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: ColorPalette.primary,
                        ),
                        value: roomValue,
                        items: snapshot.data!.map(buildMenuItem).toList(),
                        onChanged: ((roomValue) => setState(() {
                              this.roomValue = roomValue ?? "";
                            })),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Remove current or add a new room.",
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: inputControllerForRoom,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "Enter a room!";
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
                      hintText: "Enter new room...",
                    ),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorPalette.errorColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (roomValue == null) {
                              DialogUnsuccessful(
                                headertext: "No Current Room selected!",
                                subtext: "Please select a current room.",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }

                            String currentRoom = roomValue.toString();

                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to remove $currentRoom?",
                              callback: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                DialogLoading(subtext: "Removing...")
                                    .buildLoadingScreen(context);
                                await choicesReference.child("room").get().then(
                                  (snapshot) async {
                                    for (final data in snapshot.children) {
                                      if (data.value == currentRoom) {
                                        await choicesReference
                                            .child("room/${data.key}")
                                            .remove();
                                      }
                                    }
                                  },
                                ).then((value) async {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogSuccess(
                                    headertext: "Success",
                                    subtext:
                                        "Successfully removed $currentRoom in rooms!",
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(),
                                  ).buildSuccessScreen(context);
                                  await createHistory(
                                    desc: "Removed $currentRoom in rooms",
                                    timeStamp: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    userType: userType,
                                    id: userID,
                                  );
                                  setState(() {
                                    roomValue = null;
                                  });
                                }).catchError((error) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogUnsuccessful(
                                    headertext: "Error",
                                    subtext: error.toString(),
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ),
                                  ).buildUnsuccessfulScreen(context);
                                });
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "REMOVE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(ColorPalette.primary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (!formKeyForRoom.currentState!.validate()) {
                              return;
                            }

                            String input = inputControllerForRoom.text
                                .toUpperCase()
                                .trim();
                            String? key =
                                choicesReference.child("room").push().key;
                            if (snapshot.data!.contains(input)) {
                              DialogUnsuccessful(
                                headertext: "Already exist!",
                                subtext: "The input you entered already exist!",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }
                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to add $input to rooms?",
                              callback: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogLoading(subtext: "Adding...")
                                    .buildLoadingScreen(context);
                                await choicesReference
                                    .child("room/$key")
                                    .set(input)
                                    .then(
                                  (value) async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogSuccess(
                                      headertext: "Success",
                                      subtext:
                                          "Successfully added $input in rooms",
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop(),
                                    ).buildSuccessScreen(context);
                                    await createHistory(
                                      desc: "Added $input in rooms",
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      userType: userType,
                                      id: userID,
                                    );
                                    setState(() {
                                      inputControllerForRoom.text = "";
                                      roomValue = null;
                                    });
                                  },
                                ).catchError(
                                  (err) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Error",
                                      subtext: err.toString(),
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ),
                                    ).buildUnsuccessfulScreen(context);
                                  },
                                );
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(height: 1, color: ColorPalette.primary),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: getSections(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Fetching sections...',
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SpinKitThreeBounce(
                    color: ColorPalette.secondary,
                    size: 15,
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning_rounded,
                    color: ColorPalette.errorColor,
                    size: 15,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Error fetching sections.',
                    style: TextStyle(
                      color: ColorPalette.errorColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              );
            }

            return Form(
              key: formKeyForSection,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "We currently have ${snapshot.data!.length} section(s).",
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0.5),
                    decoration: const BoxDecoration(
                      color: ColorPalette.accentDarkWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          snapshot.data!.isNotEmpty
                              ? "Sections"
                              : "No Sections Currently",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        isExpanded: true,
                        iconSize: 32,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: ColorPalette.primary,
                        ),
                        value: sectionValue,
                        items: snapshot.data!.map(buildMenuItem).toList(),
                        onChanged: ((sectionValue) => setState(() {
                              this.sectionValue = sectionValue ?? "";
                            })),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Remove current or add a new section.",
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: inputControllerForSection,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "Enter a section!";
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
                      hintText: "Enter new section...",
                    ),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorPalette.errorColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (sectionValue == null) {
                              DialogUnsuccessful(
                                headertext: "No Current Section selected!",
                                subtext: "Please select a current section.",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }

                            String currentSection = sectionValue.toString();

                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to remove $currentSection?",
                              callback: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                DialogLoading(subtext: "Removing...")
                                    .buildLoadingScreen(context);
                                await choicesReference
                                    .child("section")
                                    .get()
                                    .then(
                                  (snapshot) async {
                                    for (final data in snapshot.children) {
                                      if (data.value == currentSection) {
                                        await choicesReference
                                            .child("section/${data.key}")
                                            .remove();
                                      }
                                    }
                                  },
                                ).then((value) async {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogSuccess(
                                    headertext: "Success",
                                    subtext:
                                        "Successfully removed $currentSection in sections!",
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(),
                                  ).buildSuccessScreen(context);
                                  await createHistory(
                                    desc: "Removed $currentSection in sections",
                                    timeStamp: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    userType: userType,
                                    id: userID,
                                  );
                                  setState(() {
                                    sectionValue = null;
                                  });
                                }).catchError((error) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogUnsuccessful(
                                    headertext: "Error",
                                    subtext: error.toString(),
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ),
                                  ).buildUnsuccessfulScreen(context);
                                });
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "REMOVE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(ColorPalette.primary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (!formKeyForSection.currentState!.validate()) {
                              return;
                            }

                            String input = inputControllerForSection.text
                                .toUpperCase()
                                .trim();
                            String? key =
                                choicesReference.child("section").push().key;
                            if (snapshot.data!.contains(input)) {
                              DialogUnsuccessful(
                                headertext: "Already exist!",
                                subtext: "The input you entered already exist!",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }
                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to add $input to sections?",
                              callback: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogLoading(subtext: "Adding...")
                                    .buildLoadingScreen(context);
                                await choicesReference
                                    .child("section/$key")
                                    .set(input)
                                    .then(
                                  (value) async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogSuccess(
                                      headertext: "Success",
                                      subtext:
                                          "Successfully added $input in rooms",
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop(),
                                    ).buildSuccessScreen(context);
                                    await createHistory(
                                      desc: "Added $input in sections",
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      userType: userType,
                                      id: userID,
                                    );
                                    setState(() {
                                      inputControllerForSection.text = "";
                                      sectionValue = null;
                                    });
                                  },
                                ).catchError(
                                  (err) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Error",
                                      subtext: err.toString(),
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ),
                                    ).buildUnsuccessfulScreen(context);
                                  },
                                );
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(height: 1, color: ColorPalette.primary),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: getSubjectCodes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Fetching subject codes...',
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SpinKitThreeBounce(
                    color: ColorPalette.secondary,
                    size: 15,
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning_rounded,
                    color: ColorPalette.errorColor,
                    size: 15,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Error fetching subject codes.',
                    style: TextStyle(
                      color: ColorPalette.errorColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              );
            }

            return Form(
              key: formKeyForSubject,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "We currently have ${snapshot.data!.length} subject code(s).",
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0.5),
                    decoration: const BoxDecoration(
                      color: ColorPalette.accentDarkWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          snapshot.data!.isNotEmpty
                              ? "Subject codes"
                              : "No Subject codes Currently",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        isExpanded: true,
                        iconSize: 32,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: ColorPalette.primary,
                        ),
                        value: subjectValue,
                        items: snapshot.data!.map(buildMenuItem).toList(),
                        onChanged: ((subjectValue) => setState(() {
                              this.subjectValue = subjectValue ?? "";
                            })),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Remove current or add a new subject code.",
                    style: TextStyle(
                      color: ColorPalette.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: inputControllerForSubjectCode,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "Enter a subject code!";
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
                      hintText: "Enter new subject code...",
                    ),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorPalette.errorColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (subjectValue == null) {
                              DialogUnsuccessful(
                                headertext: "No Current Subject Code selected!",
                                subtext:
                                    "Please select a Subject Code section.",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }

                            String currentSubject = subjectValue.toString();

                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to remove $currentSubject?",
                              callback: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                DialogLoading(subtext: "Removing...")
                                    .buildLoadingScreen(context);
                                await choicesReference
                                    .child("subjectCode")
                                    .get()
                                    .then(
                                  (snapshot) async {
                                    for (final data in snapshot.children) {
                                      if (data.value == currentSubject) {
                                        await choicesReference
                                            .child("subjectCode/${data.key}")
                                            .remove();
                                      }
                                    }
                                  },
                                ).then((value) async {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogSuccess(
                                    headertext: "Success",
                                    subtext:
                                        "Successfully removed $currentSubject in subject codes!",
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(),
                                  ).buildSuccessScreen(context);
                                  await createHistory(
                                    desc:
                                        "Removed $currentSubject in subject codes",
                                    timeStamp: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    userType: userType,
                                    id: userID,
                                  );
                                  setState(() {
                                    subjectValue = null;
                                  });
                                }).catchError((error) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  DialogUnsuccessful(
                                    headertext: "Error",
                                    subtext: error.toString(),
                                    textButton: "Close",
                                    callback: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ),
                                  ).buildUnsuccessfulScreen(context);
                                });
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "REMOVE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(ColorPalette.primary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          onPressed: () {
                            if (!formKeyForSubject.currentState!.validate()) {
                              return;
                            }

                            String input = inputControllerForSubjectCode.text
                                .toUpperCase()
                                .trim();
                            String? key = choicesReference
                                .child("subjectCode")
                                .push()
                                .key;
                            if (snapshot.data!.contains(input)) {
                              DialogUnsuccessful(
                                headertext: "Already exist!",
                                subtext: "The input you entered already exist!",
                                textButton: "Close",
                                callback: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              ).buildUnsuccessfulScreen(context);
                              return;
                            }
                            DialogConfirm(
                              headertext:
                                  "Are you sure you want to add $input to subject codes?",
                              callback: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogLoading(subtext: "Adding...")
                                    .buildLoadingScreen(context);
                                await choicesReference
                                    .child("subjectCode/$key")
                                    .set(input)
                                    .then(
                                  (value) async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogSuccess(
                                      headertext: "Success",
                                      subtext:
                                          "Successfully added $input in rooms",
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop(),
                                    ).buildSuccessScreen(context);
                                    await createHistory(
                                      desc: "Added $input in subject codes",
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      userType: userType,
                                      id: userID,
                                    );
                                    setState(() {
                                      inputControllerForSubjectCode.text = "";
                                      subjectValue = null;
                                    });
                                  },
                                ).catchError(
                                  (err) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Error",
                                      subtext: err.toString(),
                                      textButton: "Close",
                                      callback: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ),
                                    ).buildUnsuccessfulScreen(context);
                                  },
                                );
                              },
                            ).buildConfirmScreen(context);
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(height: 1, color: ColorPalette.primary),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<List<String>> getRooms() async {
    List<String> rooms = [];
    await choicesReference.child("room").get().then((snapshot) {
      for (final data in snapshot.children) {
        rooms.add(data.value.toString());
      }
    });

    rooms.sort();
    return rooms;
  }

  Future<List<String>> getSections() async {
    List<String> sections = [];
    await choicesReference.child("section").get().then((snapshot) {
      for (final data in snapshot.children) {
        sections.add(data.value.toString());
      }
    });

    sections.sort();
    return sections;
  }

  Future<List<String>> getSubjectCodes() async {
    List<String> subjectCodes = [];
    await choicesReference.child("subjectCode").get().then((snapshot) {
      for (final data in snapshot.children) {
        subjectCodes.add(data.value.toString());
      }
    });

    subjectCodes.sort();
    return subjectCodes;
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: ColorPalette.primary,
        ),
      ),
    );
