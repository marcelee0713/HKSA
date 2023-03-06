import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/adminPages/chart.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/pages/professorPages/info.dart';
import 'package:hksa/widgets/adminWidgets/contact/announce.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class AdminHomeContent extends StatefulWidget {
  const AdminHomeContent({super.key});

  @override
  State<AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<AdminHomeContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Have something to-do today?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.primary,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 325,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 36, 36, 36),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.campaign,
                                size: 100,
                                color: ColorPalette.accentWhite,
                              ),
                              Text(
                                "Announce",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.accentWhite),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Announce()));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 36, 36, 36),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.person,
                                size: 100,
                                color: ColorPalette.accentWhite,
                              ),
                              Text(
                                "Users",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.accentWhite),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminContacts()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 36, 36, 36),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.pie_chart,
                                size: 100,
                                color: ColorPalette.accentWhite,
                              ),
                              Text(
                                "Status",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.accentWhite),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminChart()));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 36, 36, 36),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.person_add,
                                size: 100,
                                color: ColorPalette.accentWhite,
                              ),
                              Text(
                                "Registration",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.accentWhite),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = 3;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminRegistration()));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          child: const Text(
            "About us",
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: ColorPalette.primary),
          ),
          onTap: () {
            // Have to reuse it cause why not?
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const InfoProfessor()));
          },
        )
      ],
    );
  }
}
