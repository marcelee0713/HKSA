import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/registration/admin_register_scholar_inputs.dart';
import 'package:hksa/widgets/registerWidgets/register_header.dart';

class AdminRegisterScholarPage extends StatelessWidget {
  const AdminRegisterScholarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: const IntrinsicHeight(
              child: RegisterContainer(),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterContainer extends StatelessWidget {
  const RegisterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            RegisterHeader(),
            AdminRegisterScholarInputs(),
          ],
        ),
      ),
    );
  }
}
