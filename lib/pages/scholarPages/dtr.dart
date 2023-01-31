import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_header.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_info.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:hksa/constant/colors.dart';

class DTR extends StatefulWidget {
  const DTR({Key? key}) : super(key: key);

  @override
  State<DTR> createState() => _DTRState();
}

class _DTRState extends State<DTR> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ScholarHomeHeader(),
                SizedBox(height: 35),
                ScholarHomeInputs(),
                SizedBox(height: 35),
                ScholarDTRInformation(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
