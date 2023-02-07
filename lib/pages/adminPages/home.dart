import 'package:flutter/material.dart';
import 'package:hksa/widgets/adminWidgets/home/home_content.dart';
import 'package:hksa/widgets/adminWidgets/home/home_header.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDraw(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                AdminHomeHeader(),
                SizedBox(height: 20),
                AdminHomeContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
