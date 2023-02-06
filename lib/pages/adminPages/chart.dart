import 'package:flutter/material.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';

class AdminChart extends StatefulWidget {
  const AdminChart({super.key});

  @override
  State<AdminChart> createState() => _AdminChartState();
}

class _AdminChartState extends State<AdminChart> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDraw(),
      body: Center(
        child: Text("Chart"),
      ),
    );
  }
}
