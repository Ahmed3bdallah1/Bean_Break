import 'package:bath_room_app/core/controllers/auth/auth_controller.dart';
import 'package:bath_room_app/core/network/app_constants.dart';
import 'package:bath_room_app/core/network/local/cache_helper.dart';
import 'package:bath_room_app/core/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bath_room_app/di_container.dart' as di;
import '../../core/colors/colours.dart';
import '../widgets/custom_button.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isLoading = false;

  Future<void> delete() async {
    setState(() => isLoading = true);
    final res =
        await Provider.of<AuthController>(context).deleteAccount(context);

    if (res) {
      Future.wait([
        di.sl<CacheHelper>().removeData(key: "token"),
        di.sl<CacheHelper>().removeData(key: "user_id"),
        di.sl<CacheHelper>().removeData(key: "email"),
        di.sl<CacheHelper>().removeData(key: "name"),
      ]).then((value) {
        AppConstants.userId = '';
        AppConstants.email = '';
        AppConstants.name = '';
        AppConstants.token = '';
      });
      setState(() => isLoading = false);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/beens.png",
                    height: size.height*.173,
                  ),
                  SizedBox(
                    width: size.width*.049,
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
              child: Text(
                "Are you sure you want to delete your account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ConstantsColors.navigationColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "This will be permanent and can't be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ConstantsColors.navigationColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: "Cancel",
              color: ConstantsColors.navigationColor,
              textColor: Colors.white,
              width: size.width*.51,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading == true
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "Delete Permanent",
                    color: Colors.red.shade800,
                    textColor: Colors.white,
                    width: size.width*.51,
                    // onPressed: reset,
                  ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
