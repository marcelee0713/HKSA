import 'package:flutter/material.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class AdminRegistration extends StatefulWidget {
  const AdminRegistration({super.key});

  @override
  State<AdminRegistration> createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDraw(),
      body: Center(
        child: Text("Registration"),
      ),
    );
  }
}
