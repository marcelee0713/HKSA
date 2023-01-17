import 'package:flutter/material.dart';
import '/constant/colors.dart';
import '../widgets/logInWidgets/logInHeader.dart';
import '../widgets/logInWidgets/logInInputs.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.royalGreen,
      ),
      home: Scaffold(
        backgroundColor: ColorPalette.secondary,
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: const IntrinsicHeight(
                child: LogInContainer(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogInContainer extends StatelessWidget {
  const LogInContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          LoginHeader(),
          LogInInputs(),
        ],
      ),
    );
  }
}
