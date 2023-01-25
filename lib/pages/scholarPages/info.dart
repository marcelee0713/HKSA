import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorPalette.secondary,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 18),
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
              const Text('Hello World'),
            ],
          ),
        )
    );
  }
}