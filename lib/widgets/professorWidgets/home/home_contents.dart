import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/pages/professorPages/message.dart';

class ProfessorHomeContent extends StatefulWidget {
  const ProfessorHomeContent({super.key});

  @override
  State<ProfessorHomeContent> createState() => _ProfessorHomeContentState();
}

class _ProfessorHomeContentState extends State<ProfessorHomeContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Want to know more about the HKSA?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorPalette.accentWhite,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          /*
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
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
                        children: const [
                          Icon(
                            Icons.school_rounded,
                            size: 100,
                            color: ColorPalette.primary,
                          ),
                          Text(
                            "Scholars",
                            style: TextStyle(
                              color: ColorPalette.primary,
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
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
                        children: const [
                          Icon(
                            Icons.person,
                            size: 100,
                            color: ColorPalette.primary,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                              color: ColorPalette.primary,
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          */
        ],
      ),
    );
  }
}
