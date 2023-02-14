import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/adminPages/chart.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/pages/adminPages/profile.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/pages/adminPages/reset.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';

class NavDraw extends StatefulWidget {
  const NavDraw({super.key});

  @override
  State<NavDraw> createState() => _NavDrawState();
}

int selectedIndex = 0;

class _NavDrawState extends State<NavDraw> {
  final logInBox = Hive.box("myLoginBox");
  late var userName = logInBox.get("userName");
  late var userID = logInBox.get("userID");
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: ColorPalette.primary,
        child: ListView(
          children: [
            SizedBox(
              height: 200.0,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'))),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 3.5),
                      Text(
                        userID,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            _createDrawerItem(
              icon: Icons.home,
              text: "Home",
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeAdmin()));
              },
              isSelected: selectedIndex == 0,
            ),
            const SizedBox(height: 16),
            _createDrawerItem(
              icon: Icons.contacts_rounded,
              text: "Contacts",
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminContacts()));
              },
              isSelected: selectedIndex == 1,
            ),
            const SizedBox(height: 16),
            _createDrawerItem(
              icon: Icons.pie_chart,
              text: "Chart",
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminChart()));
              },
              isSelected: selectedIndex == 2,
            ),
            const SizedBox(height: 16),
            _createDrawerItem(
              icon: Icons.person_add,
              text: "Registration",
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminRegistration()));
              },
              isSelected: selectedIndex == 3,
            ),
            const SizedBox(height: 16),
            _createDrawerItem(
                icon: Icons.refresh,
                text: "Reset",
                onTap: () {
                  setState(() {
                    selectedIndex = 4;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Reset()));
                  });
                },
                isSelected: selectedIndex == 4),
            const SizedBox(height: 16),
            const Divider(color: ColorPalette.secondary),
            _createDrawerItem(
                icon: Icons.person,
                text: "Profile",
                onTap: () {
                  setState(() {
                    selectedIndex = 5;

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminProfile()));
                  });
                },
                isSelected: selectedIndex == 5),
            const SizedBox(height: 16),
            _createDrawerItem(
              icon: Icons.logout_rounded,
              text: "Log out",
              onTap: () {
                DialogConfirm(
                    headertext: "Are you sure you want to log out?",
                    callback: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      // Might be more soon
                      // This includes the time in
                      Future.delayed(const Duration(), (() {
                        DialogLoading(subtext: "Logging out...")
                            .buildLoadingScreen(context);
                      })).whenComplete(() {
                        Future.delayed(const Duration(seconds: 3), () {
                          logInBox.put("isLoggedIn", false);
                          logInBox.put("hasTimedIn", false);
                          logInBox.put("userType", "");
                          logInBox.put("userID", "");
                          logInBox.put("userName", "");
                          logInBox.put("getTimeInLS", "");
                          logInBox.put("dateTimedIn", "");

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (Route<dynamic> route) => false);
                        });
                      });
                    }).buildConfirmScreen(context);
              },
              isSelected: selectedIndex == 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap,
      required bool isSelected}) {
    debugPrint(isSelected.toString());
    return Material(
      child: Ink(
        color: isSelected ? ColorPalette.secondary : ColorPalette.primary,
        child: ListTile(
          selected: true,
          hoverColor: Colors.white,
          title: Row(
            children: <Widget>[
              Icon(
                icon,
                color: ColorPalette.accentWhite,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: ColorPalette.accentWhite,
                    fontFamily: 'Inter',
                  ),
                ),
              )
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
