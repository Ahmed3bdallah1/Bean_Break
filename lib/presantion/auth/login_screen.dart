import 'package:bath_room_app/core/colors/colours.dart';
import 'package:bath_room_app/core/controllers/auth/auth_controller.dart';
import 'package:bath_room_app/core/routing/router.dart';
import 'package:bath_room_app/core/validators/vaildation.dart';
import 'package:bath_room_app/presantion/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custoum_text_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
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
                const SizedBox(height: 50),
                CustomTextField(
                  controller: emailController,
                  validator: validateEmail,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 30),
                Consumer<AuthController>(
                  builder: (context, controller, _) {
                    return ValueListenableBuilder<bool>(
                        valueListenable: AuthController.obsecuredNotifier,
                        builder: (context, obsecure, _) {
                          return CustomTextField(
                            controller: passwordController,
                            validator: validatePassword,
                            obscure: obsecure,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: obsecure == false
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            suffixOnTap: () {
                              final x = controller.isObsecurd;
                              controller.onObsecured(!x);
                            },
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.forgetPassword);
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                            color: ConstantsColors.navigationColor,
                            fontSize: 19,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Consumer<AuthController>(
                      builder: (context, controller, _) {
                        return Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  controller
                                      .onRemember(!controller.isRemembered);
                                },
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      AuthController.rememberNotifier,
                                  builder: (context, listner, _) {
                                    print("listner is: $listner");
                                    return listner
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.white,
                                          );
                                  },
                                )),
                            const SizedBox(width: 5),
                            const Text(
                              "Remember",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Stack(children: [
                  Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 20),
                            blurRadius: 8,
                            spreadRadius: 3,
                            color: Colors.black.withOpacity(.3))
                      ],
                    ),
                  ),
                  CustomButton(
                    text: "Login",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await Provider.of<AuthController>(context,
                                listen: false)
                            .login(context,
                                email: emailController.text,
                                password: passwordController.text,
                                remember:
                                    AuthController.rememberNotifier.value);
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      SizedBox(width: 10),
                      Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Create account",
                  width: size.width*.51,
                  color: ConstantsColors.bottomSheetBackGround,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.createAccount);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
