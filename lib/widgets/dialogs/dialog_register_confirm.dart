import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogRegisterConfirm {
  final String studentNumber;
  final String name;
  final String course;
  final String email;
  final String phoneNumber;
  final String password;
  final String hkType;
  final String hours;
  final String status;
  final String totalHoursInDisplay;
  final String totalHoursInDuration;
  final String totalHoursRequired;
  final String isFinished;
  final String onSiteDay1;
  final String onSiteDay2;
  final String vacantTimeDay1;
  final String vacantTimeDay2;
  final String wholeDayVacantTime;
  final String scholarType;
  final String town;
  final File image;
  final VoidCallback callback;

  DialogRegisterConfirm(
      this.studentNumber,
      this.name,
      this.course,
      this.email,
      this.phoneNumber,
      this.password,
      this.hkType,
      this.hours,
      this.status,
      this.totalHoursInDisplay,
      this.totalHoursInDuration,
      this.totalHoursRequired,
      this.isFinished,
      this.onSiteDay1,
      this.onSiteDay2,
      this.vacantTimeDay1,
      this.vacantTimeDay2,
      this.wholeDayVacantTime,
      this.scholarType,
      this.town,
      this.image,
      this.callback);

  build(BuildContext context) {
    bool? isChecked = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: ColorPalette.primary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Confirmation!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            height: 1,
                            color: ColorPalette.accentWhite,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Before we let you create an account. Check if your information if it's right!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 300,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorPalette.accentWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 125,
                                  height: 125,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipOval(
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name: $name",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Student Number: $studentNumber",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Phone Number: $phoneNumber",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Email: $email",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Password: $password",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "HK Type: $hkType",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Scholar Type: $scholarType",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "On Site Day 1: $onSiteDay1",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "On Vacant Time Day 1: $vacantTimeDay1",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "On Site Day 2: $onSiteDay2",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "On Vacant Time Day 2: $vacantTimeDay2",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Whole day Vacant: $wholeDayVacantTime",
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Town: $town",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: isChecked,
                              activeColor: ColorPalette.primary,
                              checkColor: ColorPalette.primary,
                              fillColor: MaterialStateProperty.all(
                                  ColorPalette.accentWhite),
                              onChanged: (newBool) {
                                setState(() {
                                  isChecked = newBool;
                                });
                              }),
                          const Text(
                            "Please check to confirm",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: isChecked == true
                            ? (() => setState(
                                  () {
                                    callback();
                                  },
                                ))
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBackgroundColor:
                              const Color.fromARGB(137, 114, 177, 139),
                        ),
                        child: const Text(
                          "CONFIRM",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
