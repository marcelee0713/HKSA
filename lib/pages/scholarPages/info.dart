import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/widgets/scholarWidgets/info/info_widget.dart';

import '../../constant/colors.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logInBox = Hive.box("myLoginBox");
    late var scholarType = logInBox.get("scholarType");
    return scholarType == "Faci"
        ? const Scaffold(
            body: InfoWidget(),
            backgroundColor: ColorPalette.accentWhite,
          )
        : const InfoWidget();
  }
}
