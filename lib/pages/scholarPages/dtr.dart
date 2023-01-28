import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_header.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:hksa/constant/colors.dart';

class DTR extends StatefulWidget {
  const DTR({Key? key}) : super(key: key);

  @override
  State<DTR> createState() => _DTRState();
}

class _DTRState extends State<DTR> {
  final _myLoginBox = Hive.box('myLoginBox');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ScholarHomeHeader(),
            const SizedBox(height: 35),
            const ScholarHomeInputs(),
            const SizedBox(height: 35),
            SizedBox(
              child: InkWell(
                onTap: (() {
                  setState(
                    () {
                      // Might be more soon
                      // This includes the time in
                      DialogLoading(subtext: "Logging out..")
                          .buildLoadingScreen(context);

                      Future.delayed(const Duration(seconds: 2), (() {
                        _myLoginBox.put("isLoggedIn", false);
                        _myLoginBox.put("hasTimedIn", false);
                        _myLoginBox.put("userType", "");
                        _myLoginBox.put("userID", "");
                        _myLoginBox.put("userName", "");
                        _myLoginBox.put("getTimeInLS", "");

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (Route<dynamic> route) => false);
                      }));
                    },
                  );
                }),
                child: const Text(
                  "Log out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.primary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
