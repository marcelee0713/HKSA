import 'package:flutter/material.dart';
import '/constant/colors.dart';
import '../widgets/logInWidgets/log_in_header.dart';
import '../widgets/logInWidgets/log_in_inputs.dart';
import 'package:firebase_core/firebase_core.dart';

final Future<FirebaseApp> _fApp = Firebase.initializeApp();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.royalGreen,
      ),
      home: Scaffold(
        backgroundColor: ColorPalette.secondary,
        // Always put FutureBuilder if you're using firebase?
        // Is it? I need to research this up its 11:34pm i have class at 7am omaygot.
        body: FutureBuilder(
          future: _fApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // This is supposed to return something like a modal
              // Modal of an error can't fetch.
              return const Text("Error fetching the data!");
            } else if (snapshot.hasData) {
              return LayoutBuilder(
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
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
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
