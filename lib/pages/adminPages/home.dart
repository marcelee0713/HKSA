import 'package:flutter/material.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDraw(),
      body: Center(
        child: Text("Home"),
      ),
    );
  }
}
