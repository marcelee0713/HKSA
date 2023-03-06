import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/adminWidgets/reset/reset_buttons.dart';
import 'package:hksa/widgets/adminWidgets/reset/reset_header.dart';

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
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: ResetHeader(),
                ),
                SizedBox(height: 8),
                ResetButtons()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
