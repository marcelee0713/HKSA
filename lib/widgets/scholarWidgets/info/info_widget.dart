import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorPalette.secondary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 8,
              shadowColor: Colors.black,
              color: const Color(0xff00402b),
              child: Column(
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'App Description',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Frank Ruhl Libre',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21, vertical: 35),
                    child: Text(
                      'Our group is trying to achieve an easy, paperless'
                      ' and less hassle transaction in HK activities. This app '
                      'will greatly help not only the HK scholars but also the '
                      'CSDL department holding the HK scholars for updates.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "PROGRAMMERS:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: HKSAStrings.members.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(
                        textAlign: TextAlign.center,
                        HKSAStrings.members[index],
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
