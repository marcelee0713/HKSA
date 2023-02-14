import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/adminWidgets/registration/admin_register_professor.dart';
import 'package:hksa/widgets/adminWidgets/registration/admin_register_scholar.dart';

class AdminRegistration extends StatefulWidget {
  const AdminRegistration({super.key});

  @override
  State<AdminRegistration> createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDraw(),
      body: Stack(
        children: [
          Builder(builder: (context) {
            return SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 40,
                    color: ColorPalette.primary,
                  ),
                ),
              ),
            );
          }),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      )),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "REGISTRATION",
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Frank Ruhl Libre',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminRegisterScholarPage()));
                        },
                        child: const Text(
                          "SCHOLAR",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminRegisterProfessorPage()));
                        },
                        child: const Text(
                          "PROF.",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
