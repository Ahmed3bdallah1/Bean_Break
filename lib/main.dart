import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:beak_break/presantion/auth/onboarding.dart';
import 'package:beak_break/presantion/home/widgets/navigation.dart';
import 'package:beak_break/presantion/widgets/custom_show_dialog.dart';
import 'package:flutter/services.dart';
import 'package:google_huawei_availability/google_huawei_availability.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'core/colors/colours.dart';
import 'core/controllers/auth/auth_controller.dart';
import 'core/controllers/home/home_controller.dart';
import 'core/controllers/location/location_controller.dart';
import 'core/controllers/reviews/reviews_controller.dart';
import 'core/network/app_constants.dart';
import 'core/network/local/cache_helper.dart';
import 'core/routing/router.dart';
import 'di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await di.init();
  AppConstants.token = di.sl<CacheHelper>().getData(key: "token") ?? "";
  AppConstants.userId = di.sl<CacheHelper>().getData(key: "userId") ?? "";
  AppConstants.email = di.sl<CacheHelper>().getData(key: "email") ?? "";
  AppConstants.name = di.sl<CacheHelper>().getData(key: "name") ?? "";
  print("token is:${AppConstants.token}");
  print("email is:${AppConstants.email}");
  print("id is:${AppConstants.userId}");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => di.sl<HomeController>(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => di.sl<AuthController>(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => di.sl<LocationController>(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              di.sl<ReviewsController>()..getMyReviews(context),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'Bean Break',
        theme: ThemeData(
          scaffoldBackgroundColor: ConstantsColors.background,
        ),
        onGenerateRoute: Routes.onGenerateRoute,
        home: AnimatedSplashScreen(
          backgroundColor: ConstantsColors.background,
          splashIconSize: 200,
          splash: Column(
            children: [
              Image.asset(
                'assets/beens.png',
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(
                "BeanBreak",
                style: TextStyle(
                  fontSize: 40,
                  color: ConstantsColors.navigationColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          nextScreen: AppConstants.token != ""
              ? const NavigationBarConfig()
              : const WelcomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          duration: 3000,
        ),
      ),
    );
  }
}

// this is the splash screen if i want to block huawei users from entering the app
class SplashView extends StatefulWidget {
  const SplashView({
    super.key,
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<bool?> isGoogle = GoogleHuaweiAvailability.isGoogleServiceAvailable;
  bool move = false;

  Future<bool> services() async {
    bool sevices = await isGoogle ?? false;
    return sevices;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services().then((value) {
      if (value == false) {
        return showCustomDialog(
          context,
          title: "Service unavailable",
          body: "please check google play services on your device..",
          actionName: "Leave",
          onPressed: () {
            SystemNavigator.pop(animated: true);
          },
        );
      } else {
        setState(() {
          move = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !move
        ? Scaffold(
            backgroundColor: ConstantsColors.background,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/beens.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "BeanBreak",
                  style: TextStyle(
                    fontSize: 40,
                    color: ConstantsColors.navigationColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : AnimatedSplashScreen(
            backgroundColor: ConstantsColors.background,
            splashIconSize: 200,
            splash: Column(
              children: [
                Image.asset(
                  'assets/beens.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "BeanBreak",
                  style: TextStyle(
                    fontSize: 40,
                    color: ConstantsColors.navigationColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            nextScreen: move == false
                ? const SizedBox()
                : AppConstants.token != ""
                    ? const NavigationBarConfig()
                    : const WelcomeScreen(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            duration: 3000,
          );
  }
}
