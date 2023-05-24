import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_header.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_info.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

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

  Future createHistory(
      {required String desc,
      required String timeStamp,
      required String userType,
      required String id}) async {
    try {
      DatabaseReference dbReference =
          FirebaseDatabase.instance.ref().child('historylogs/$id');
      String? key = dbReference.push().key;

      final json = {
        'desc': desc,
        'timeStamp': timeStamp,
        'userType': userType,
        'id': id,
      };

      await dbReference.child(key!).set(json);
    } catch (error) {
      rethrow;
    }
  }
}
