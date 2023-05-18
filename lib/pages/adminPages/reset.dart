import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/adminWidgets/reset/old_dtr_link.dart';
import 'package:hksa/widgets/adminWidgets/reset/reset_buttons.dart';
import 'package:hksa/widgets/adminWidgets/reset/reset_header.dart';
import 'package:hksa/widgets/adminWidgets/reset/schedule_choices.dart';
import 'package:hksa/widgets/adminWidgets/reset/settings_header.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      drawer: const NavDraw(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
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
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    GreetingsHeader(),
                    SizedBox(height: 10),
                    UploadGoogleDrivePage(),
                    SizedBox(height: 32),
                    ScheduleChoices(),
                    SizedBox(height: 32),
                    ResetHeader(),
                    SizedBox(height: 10),
                    ResetButtons(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
