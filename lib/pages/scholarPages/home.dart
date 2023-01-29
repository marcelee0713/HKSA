import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/scholarPages/chart.dart';
import 'messages.dart';
//import 'chart.dart';
import 'dtr.dart';
import 'profile.dart';
import 'info.dart';
import 'package:hksa/widgets/scholarWidgets/chart/chart_v00.dart';

/*This class is the bottom navigation bar of the app
 * 1) Create a UI for navigation bar
 * 2) Instantiate an array that would hold pages' index
 * 3) Display appropriate buttons that can be interacted with
 * 4) Call pages on click to replace existing widget in this Scaffold()
 */
class HomeScholar extends StatefulWidget {
  const HomeScholar({super.key});

  @override
  State<HomeScholar> createState() => _HomeScholarState();
}

class _HomeScholarState extends State<HomeScholar> {
  final _myLoginBox = Hive.box('myLoginBox');
  // #2 is the page index of dtr.dart and is the first priority display
  int pageIndex = 2;
  final pages = [
    const Messages(),
    const Chart(),
    const DTR(),
    const Profile(),
    const Info(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // responsible for calling respective pages
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: ColorPalette.primary,
          /* if you want smooth borders
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          */
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.pie_chart,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.pie_chart_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.timer_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              icon: pageIndex == 4
                  ? const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
