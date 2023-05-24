import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/professorPages/info.dart';
import 'package:hksa/widgets/professorWidgets/home/home_contents.dart';
import 'package:hksa/widgets/professorWidgets/home/home_header.dart';

class ProfLandingPage extends StatefulWidget {
  const ProfLandingPage({super.key});

  @override
  State<ProfLandingPage> createState() => _ProfLandingPageState();
}

class _ProfLandingPageState extends State<ProfLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ProfessorHomeHeader(),
                const SizedBox(height: 20),
                const ProfessorHomeContent(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoProfessor()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.accentDarkWhite,
                  ),
                  child: const Text(
                    "About us",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
