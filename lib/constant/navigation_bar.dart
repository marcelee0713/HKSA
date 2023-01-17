import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/messages.dart';
import 'package:hksa/pages/chart.dart';
import 'package:hksa/pages/home.dart';
import 'package:hksa/pages/profile.dart';
import 'package:hksa/pages/info.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int pageIndex = 0;

  final pages = [
    const Messages(),
    const Chart(),
    const Home(),
    const Profile(),
    const Info(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: ColorPalette.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10,
            ),
          ),
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
                Icons.home,
                color: Colors.white,
                size: 35,
              )
                  : const Icon(
                Icons.home_outlined,
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