import 'package:bath_room_app/core/routing/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors/colours.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/validators/vaildation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custoum_text_filed.dart';

class ResetPasswordEmail extends StatefulWidget {
  const ResetPasswordEmail({super.key});

  @override
  State<ResetPasswordEmail> createState() => _ResetPasswordEmailState();
}

class _ResetPasswordEmailState extends State<ResetPasswordEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/beens.png",
                          height: 150,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(
                            "Password Reset",
                            style: TextStyle(
                                fontSize: 35,
                                color: ConstantsColors.navigationColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Enter email for verification code',
                            style: TextStyle(
                                color: ConstantsColors.navigationColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    controller: emailController,
                    validator: validateEmail,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Send Email",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final res = await Provider.of<AuthController>(context,
                                listen: false)
                            .sendOtpCode(context, email: emailController.text);
                        if (res == true) {
                          Navigator.pushNamed(context, Routes.resetPassword);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
