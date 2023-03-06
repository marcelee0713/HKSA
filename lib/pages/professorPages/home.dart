import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/professorPages/landing_page.dart';
import 'package:hksa/pages/professorPages/message.dart';
import 'package:hksa/pages/professorPages/profile.dart';

class HomeProfessor extends StatefulWidget {
  const HomeProfessor({super.key});

  @override
  State<HomeProfessor> createState() => _HomeProfessorState();
}

class _HomeProfessorState extends State<HomeProfessor> {
  int pageIndexProf = 1;
  final pages = const [
    Messages(),
    ProfLandingPage(),
    ProfProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: pages[pageIndexProf],
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: ColorPalette.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndexProf = 0;
                });
              },
              icon: pageIndexProf == 0
                  ? const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndexProf = 1;
                });
              },
              icon: pageIndexProf == 1
                  ? const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndexProf = 2;
                });
              },
              icon: pageIndexProf == 2
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
