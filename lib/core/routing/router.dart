import 'package:bath_room_app/presantion/auth/delete_accont_screen.dart';
import 'package:bath_room_app/presantion/auth/reset_password_email.dart';
import 'package:bath_room_app/presantion/auth/reset_password_screen.dart';
import 'package:bath_room_app/presantion/auth/sginup_screen.dart';
import 'package:bath_room_app/presantion/home/widgets/navigation.dart';
import 'package:bath_room_app/presantion/profile/reviews_screen.dart';
import 'package:flutter/material.dart';

import '../../presantion/auth/login_screen.dart';

class Routes {
  static const createAccount = '/create-account';
  static const login = '/login';
  static const home = '/home';
  static const reviews = '/reviews';
  static const resetPassword = '/reset_password';
  static const forgetPassword = '/forget_password';
  static const deleteAccount = '/delete_account';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const NavigationBarConfig());

      case reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());

      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case forgetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordEmail());

      case deleteAccount:
        return MaterialPageRoute(builder: (_) => const DeleteAccountScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
