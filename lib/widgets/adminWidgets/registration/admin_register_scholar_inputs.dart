import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/adminWidgets/registration/admin_register_scholar_profilepicture.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class AdminRegisterScholarInputs extends StatefulWidget {
  const AdminRegisterScholarInputs({super.key});

  @override
  State<AdminRegisterScholarInputs> createState() =>
      _AdminRegisterScholarInputsState();
}

class _AdminRegisterScholarInputsState
    extends State<AdminRegisterScholarInputs> {
  final _myRegBox = Hive.box('myRegistrationBox');
  // For DropDown Default Values
  String? coursesValue;
  String? hkTypeValue;
  //sakin ulit
  String? vacantTimeValue;
  String? onSiteValue;
  String? vacantTime2Value;
  String? onSite2Value;
  String? vacantDayValue;
  String? faciTypeValue;
  String? townValue;
  //HANGGANG DITO

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;
  final _inputControllerStudentNumberID = TextEditingController();
  final _inputControllerLastName = TextEditingController();
  final _inputControllerFirstName = TextEditingController();
  final _inputControllerMiddleName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _cfrmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _testReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/");
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: ColorPalette.primary),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Basic Information:",
              style: TextStyle(
                color: ColorPalette.primary,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _inputControllerStudentNumberID,
            maxLength: 20,
            validator: (value) {
              final bool studentIdValid = RegExp(r"^[0-9-]+$").hasMatch(value!);
              if (studentIdValid && value.length >= 10) {
                return null;
              } else if (value.length <= 9 && value.isNotEmpty) {
                return "Input is too short.";
              } else if (value.isEmpty) {
                return "Enter Input.";
              } else {
                return "Enter valid school ID.";
              }
            },
            keyboardType: TextInputType.number,
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
              hintText: "Student Number (XX-XNXX-XXXXX)",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerLastName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your last name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
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
              hintText: "Last Name",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerFirstName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your first name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
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
                hintText: "First name"),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerMiddleName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your middle name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
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
                hintText: "Middle name"),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerPhoneNumber,
            maxLength: 11,
            validator: (value) {
              final bool phoneValid =
                  RegExp(r"^(09|\+639)\d{9}$").hasMatch(value!);
              if (phoneValid) {
                return null;
              } else if (value.length <= 11 && !phoneValid) {
                return "Invalid input.";
              } else if (value.length <= 10 && value.isNotEmpty) {
                return "Input is too short.";
              } else {
                return "Enter an input.";
              }
            },
            keyboardType: TextInputType.phone,
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
              hintText: "Phone Number",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.accentDarkWhite,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text(
                  "Courses",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                value: coursesValue,
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                items: HKSAStrings.courses.map(buildMenuItemCourses).toList(),
                onChanged: ((coursesValue) => setState(() {
                      this.coursesValue = coursesValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.accentDarkWhite,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text(
                  "Towns",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                value: townValue,
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                items: HKSAStrings.towns.map(buildMenuItemTowns).toList(),
                onChanged: ((townValue) => setState(() {
                      this.townValue = townValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: ColorPalette.primary),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dependent Information:",
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
              "Please choose on what they are assigned! Since they rely on other information also.",
              style: TextStyle(
                color: ColorPalette.primary,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.accentDarkWhite,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text(
                  "HK Type",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                value: hkTypeValue,
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                items: HKSAStrings.hkTypes.map(buildMenuItemHKTypes).toList(),
                onChanged: ((hkTypeValue) => setState(() {
                      this.hkTypeValue = hkTypeValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorPalette.accentDarkWhite),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text(
                  "Faci Type",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                value: faciTypeValue,
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                items: HKSAStrings.facitype.map(buildMenuItemFaciType).toList(),
                onChanged: ((faciTypeValue) => setState(() {
                      this.faciTypeValue = faciTypeValue ?? "";
                      if (faciTypeValue == "Non-Faci") {
                        vacantTimeValue = "NONE";
                        onSiteValue = "NONE";
                        vacantTime2Value = "NONE";
                        onSite2Value = "NONE";
                        vacantDayValue = "NONE";
                      } else {
                        vacantTimeValue = null;
                        onSiteValue = null;
                        vacantTime2Value = null;
                        onSite2Value = null;
                        vacantDayValue = null;
                      }
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: ColorPalette.primary),
          faciTypeValue == "Faci"
              ? Column(
                  children: [
                    const SizedBox(height: 18),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Schedule Information:",
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
                        "This section will only available if the scholar is a Faci and enter their information wisely!",
                        style: TextStyle(
                          color: ColorPalette.primary,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorPalette.accentDarkWhite),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Day 1 - Onsite",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: onSiteValue,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.onsite
                              .map(buildMenuItemOnsite)
                              .toList(),
                          onChanged: ((onSiteValue) => setState(() {
                                this.onSiteValue = onSiteValue ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Day 1 - Vacant Time",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: vacantTimeValue,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.vacanttime
                              .map(buildMenuItemVacantTime)
                              .toList(),
                          onChanged: ((vacantTimeValue) => setState(() {
                                this.vacantTimeValue = vacantTimeValue ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorPalette.accentDarkWhite),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Day 2 - Onsite",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: onSite2Value,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.onsite
                              .map(buildMenuItemOnsiteDay2)
                              .toList(),
                          onChanged: ((onSite2Value) => setState(() {
                                this.onSite2Value = onSite2Value ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Day 2 - Vacant Time",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: vacantTime2Value,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.vacanttime
                              .map(buildMenuItemVacantTimeDay2)
                              .toList(),
                          onChanged: ((vacantTime2Value) => setState(() {
                                this.vacantTime2Value = vacantTime2Value ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Vacant Day ",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: vacantDayValue,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.vacantday
                              .map(buildMenuItemVacantTimeDay2)
                              .toList(),
                          onChanged: ((vacantDayValue) => setState(() {
                                this.vacantDayValue = vacantDayValue ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(height: 1, color: ColorPalette.primary),
                    const SizedBox(height: 18),
                  ],
                )
              : const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerEmail,
            validator: (value) {
              // Email RegEx Validation
              final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!);
              if (value.isNotEmpty && emailValid) {
                return null;
              } else {
                return "Invalid input.";
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
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
              hintText: "Email",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerPassword,
            obscureText: !_passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              final bool passwordValid = RegExp(
                      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-.+=_]).{8,}$")
                  .hasMatch(value!);
              if (passwordValid) {
                return null;
              } else {
                return "Invalid Input.";
              }
            },
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
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
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              hintText: "Password",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Note: Password must be at least 8 characters, at least one uppercase, number, and special characters.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: ColorPalette.primary,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerCfrmPassword,
            obscureText: !_cfrmPasswordVisible,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              final bool cfrmPasswordValid = _inputControllerPassword.text ==
                  _inputControllerCfrmPassword.text;
              if (cfrmPasswordValid) {
                return null;
              } else if (value!.isEmpty) {
                return 'Enter input.';
              } else {
                return "Password not match";
              }
            },
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
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
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _cfrmPasswordVisible = !_cfrmPasswordVisible;
                  });
                },
                icon: Icon(
                  _cfrmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
              hintText: "Confirm Password",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 125,
            height: 60,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorPalette.primary),
              ),
              onPressed: (() {
                setState(() {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else if (coursesValue == null ||
                      hkTypeValue == null ||
                      vacantTimeValue == null ||
                      onSiteValue == null ||
                      vacantTime2Value == null ||
                      onSite2Value == null ||
                      vacantDayValue == null ||
                      faciTypeValue == null ||
                      townValue == null) {
                    DialogUnsuccessful(
                      headertext: "Fill all the corresponding inputs!",
                      subtext: "Seems like there's something you missed?",
                      textButton: "Close",
                      callback: (() =>
                          Navigator.of(context, rootNavigator: true).pop()),
                    ).buildUnsuccessfulScreen(context);
                    return;
                  }
                  // This is where it finds the user in the firebase database
                  // And if it did find it will log in depends on the user type
                  // if not. It will pop up a modal that it will show
                  // NO USER FOUND

                  // Show loading screen for 2 seconds
                  DialogLoading(subtext: "Validating...")
                      .buildLoadingScreen(context);

                  String studentNumber =
                      _inputControllerStudentNumberID.text.trim();
                  String fullName =
                      "${_inputControllerLastName.text.trim()} ${_inputControllerFirstName.text.trim()} ${_inputControllerMiddleName.text.trim()}";
                  String? course = coursesValue;
                  String? hkType = hkTypeValue;
                  String? onSite1 = onSiteValue;
                  String? onSite2 = onSite2Value;
                  String? vacantTime1 = vacantTimeValue;
                  String? vacantTime2 = vacantTime2Value;
                  String? vacantDay = vacantDayValue;
                  String? scholarType = faciTypeValue;
                  String? town = townValue;
                  String email = _inputControllerEmail.text.trim();
                  String phoneNumber = _inputControllerPhoneNumber.text.trim();
                  String password = _inputControllerCfrmPassword.text.trim();
                  String hours = "0";
                  String status = "active";
                  String totalHoursInDisplay = "0:00:00";
                  String totalHoursInDuration = "0:00:00.000000";
                  String totalHoursRequired = "";
                  String isFinished = "false";

                  bool userExist = false;

                  Future.delayed(
                      const Duration(seconds: 2),
                      (() => {
                            _testReference.get().then((snapshot) {
                              for (final test in snapshot.children) {
                                if (test.key == studentNumber) {
                                  userExist = true;
                                  break;
                                }
                              }
                            })
                          })).whenComplete(() => {
                        Future.delayed(const Duration(milliseconds: 2500),
                            () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          if (userExist) {
                            // Show a new a dialog that this user already exist
                            DialogUnsuccessful(
                              headertext: "Account already exist!",
                              subtext:
                                  "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                              textButton: "Close",
                              callback: (() =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop()),
                            ).buildUnsuccessfulScreen(context);
                          } else {
                            _myRegBox.put("studentNumber", studentNumber);
                            _myRegBox.put("name", fullName);
                            _myRegBox.put("course", course);
                            _myRegBox.put("email", email);
                            _myRegBox.put("phoneNumber", phoneNumber);
                            _myRegBox.put("password", password);
                            _myRegBox.put("hkType", hkType);
                            _myRegBox.put("hours", hours);
                            _myRegBox.put("status", status);
                            _myRegBox.put(
                                "totalHoursInDisplay", totalHoursInDisplay);
                            _myRegBox.put(
                                "totalHoursInDuration", totalHoursInDuration);
                            _myRegBox.put(
                                "totalHoursRequired", totalHoursRequired);
                            _myRegBox.put("isFinished", isFinished);
                            _myRegBox.put("onSiteDay1", onSite1);
                            _myRegBox.put("onSiteDay2", onSite2);
                            _myRegBox.put("vacantTimeDay1", vacantTime1);
                            _myRegBox.put("vacantTimeDay2", vacantTime2);
                            _myRegBox.put("wholeDayVacantTime", vacantDay);
                            _myRegBox.put("scholarType", scholarType);
                            _myRegBox.put("town", town);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminProfilePictureScholar(),
                              ),
                            );
                          }
                        })
                      });
                });
              }),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Frank Ruhl Libre',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItemCourses(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemHKTypes(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  //sakin ulit to pababa
  DropdownMenuItem<String> buildMenuItemVacantTime(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemOnsite(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemVacantTimeDay2(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemOnsiteDay2(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemVacantday(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemFaciType(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
  DropdownMenuItem<String> buildMenuItemTowns(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
}
