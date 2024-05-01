import 'package:bath_room_app/core/colors/colours.dart';
import 'package:bath_room_app/core/controllers/auth/auth_controller.dart';
import 'package:bath_room_app/core/network/app_constants.dart';
import 'package:bath_room_app/core/network/local/cache_helper.dart';
import 'package:bath_room_app/core/routing/router.dart';
import 'package:bath_room_app/presantion/widgets/custom_show_dialog.dart';
import 'package:bath_room_app/presantion/widgets/custom_switcher.dart';
import 'package:bath_room_app/presantion/widgets/snak_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/validators/vaildation.dart';
import '../widgets/custoum_text_filed.dart';
import 'package:bath_room_app/di_container.dart' as di;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .86,
          child: Consumer<AuthController>(
            builder: (context, controller, _) {
              return SingleChildScrollView(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "My details:",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: ConstantsColors.navigationColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();

                                      if (AppConstants.userId == '') {
                                        showCustomDialog(
                                          context,
                                          title: "Unauthorized",
                                          body: "please login first?",
                                          actionName: "login",
                                          onPressed: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.login,
                                                (route) => false);
                                          },
                                        );
                                      } else {
                                        showCustomDialog(
                                          context,
                                          title: "confirmation",
                                          body:
                                              "are you sure u want to edit your email?",
                                          actionName: "confirm",
                                          onPressed: () async {
                                            await Provider.of<AuthController>(
                                                    context,
                                                    listen: false)
                                                .editAccount(
                                              context,
                                              name: nameController.text,
                                              email: emailController.text,
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Icon(Icons.edit,
                                      color: ConstantsColors.navigationColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              validator: validateName,
                              controller: nameController,
                              prefixIcon: Icons.person,
                              readOnly: true,
                              hintText: AppConstants.name,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              validator: validateEmail,
                              controller: emailController,
                              prefixIcon: Icons.email,
                              hintText: AppConstants.email,
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            const CustomSwitcher(title: "Push Notifications"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomRowButton(
                                title: "Reset Password",
                                onTap: () {
                                  if (AppConstants.token == '') {
                                    showCustomDialog(
                                      context,
                                      title: "Unauthorized",
                                      body: "please login first to proceed?",
                                      actionName: "login",
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.login,
                                            (route) => false);
                                      },
                                    );
                                  } else {
                                    Provider.of<AuthController>(context,
                                            listen: false)
                                        .sendOtpCode(context);
                                    Navigator.pushNamed(
                                        context, Routes.resetPassword);
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomRowButton(
                                title: "My Reviews",
                                onTap: () async {
                                  if (AppConstants.token == '') {
                                    showCustomDialog(
                                      context,
                                      title: "Unauthorized",
                                      body: "please login first to proceed?",
                                      actionName: "login",
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.login,
                                            (route) => false);
                                      },
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                        context, Routes.reviews);
                                  }
                                },
                              ),
                            ),
                            // Consumer<ReviewsController>(
                            //     builder: (context, controller, _) {
                            //   Future.wait([
                            //     controller.getMyReviews(
                            //         context, AppConstants.userId)
                            //   ]);
                            //   return ValueListenableBuilder<List<ReviewModel>>(
                            //       valueListenable:
                            //           ReviewsController.myReviewsNotifier,
                            //       builder: (context, listner, _) {
                            //         if (listner.isEmpty) {
                            //           return const SizedBox();
                            //         }
                            //
                            //       });
                            // }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      children: [
                        AppConstants.token != ''
                            ? TextButton(
                                onPressed: () {
                                  di
                                      .sl<CacheHelper>()
                                      .removeData(key: "token")
                                      .then(
                                    (value) {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.login,
                                          (route) => false).catchError(
                                        (e) {
                                          return showSnackBar(
                                            context,
                                            text: "something went wrong, $e",
                                            color: Colors.red,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Log out",
                                  style: TextStyle(
                                      color: ConstantsColors.fillColor3,
                                      fontSize: 20),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.login, (route) => false);
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                      color: ConstantsColors.fillColor3,
                                      fontSize: 20),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        AppConstants.token != ''
                            ? TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.deleteAccount);
                                },
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                      color: ConstantsColors.navigationColor2,
                                      fontSize: 20),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
