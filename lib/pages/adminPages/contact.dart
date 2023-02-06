import 'package:flutter/material.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class AdminContacts extends StatefulWidget {
  const AdminContacts({super.key});

  @override
  State<AdminContacts> createState() => _AdminContactsState();
}

class _AdminContactsState extends State<AdminContacts> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDraw(),
      body: Center(
        child: Text("Contact"),
      ),
    );
  }
}
