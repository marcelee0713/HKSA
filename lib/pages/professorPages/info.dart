import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/scholarWidgets/info/info_widget.dart';

class InfoProfessor extends StatefulWidget {
  const InfoProfessor({super.key});

  @override
  State<InfoProfessor> createState() => _InfoProfessorState();
}

class _InfoProfessorState extends State<InfoProfessor> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InfoWidget(),
      backgroundColor: ColorPalette.accentWhite,
    );
  }
}
