import 'package:bath_room_app/core/controllers/auth/auth_controller.dart';
import 'package:bath_room_app/core/validators/vaildation.dart';
import 'package:bath_room_app/presantion/home/widgets/navigation.dart';
import 'package:bath_room_app/presantion/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors/colours.dart';
import '../widgets/custoum_text_filed.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController controller = TextEditingController();

  void reset() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final res = await Provider.of<AuthController>(context).resetPassword(
        context,
        password: password.text,
        verificationCode: controller.text,
      );
      if (res == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarConfig()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/beens.png",
                        height: size.height * .173,
                      ),
                      SizedBox(
                        width: size.width * .049,
                      ),
                      Flexible(
                        child: Text(
                          "BeanBreak",
                          style: TextStyle(
                              fontSize: 40,
                              color: ConstantsColors.navigationColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Enter new password",
                        style: TextStyle(
                            color: ConstantsColors.navigationColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  validator: validatePassword,
                  controller: password,
                  prefixIcon: Icons.password,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Confirm new password",
                        style: TextStyle(
                            color: ConstantsColors.navigationColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  validator: (confirm) {
                    return validateConfirmPassword(password.text, confirm);
                  },
                  controller: confirmPassword,
                  prefixIcon: Icons.password,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Enter verification code",
                        style: TextStyle(
                            color: ConstantsColors.navigationColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  validator: validateVerification,
                  controller: controller,
                  prefixIcon: Icons.password,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "- reset code sent to your email,please check your email enter your code and click next",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "- if there's nothing sent to your email please try again later or restart the app",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: "Reset Password",
                  width: size.width * .51,
                  onPressed: reset,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
