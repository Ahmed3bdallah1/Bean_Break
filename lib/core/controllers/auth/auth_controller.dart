import 'package:beak_break/core/network/app_constants.dart';
import 'package:beak_break/core/network/data/auth_data_source/auth_data_source.dart';
import 'package:beak_break/models/user_models/all_users_model.dart';
import 'package:beak_break/models/user_models/user_model.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthDataSource authDataSource;

  AuthController({required this.authDataSource});

  List<AllUsersData> usersList = [];

  UserModel? userModel;

  static final ValueNotifier<bool> rememberNotifier = ValueNotifier(true);
  static final ValueNotifier<bool> obsecuredNotifier = ValueNotifier(true);
  bool isRemembered = true;
  bool isObsecurd = true;

  Future<List<AllUsersData>?> allUsers() async {
    try {
      final res = await authDataSource.allUsers();
      usersList = res ?? [];
      notifyListeners();
      return usersList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel?> login(
    BuildContext context, {
    required String email,
    required String password,
    bool? remember,
  }) async {
    userModel =
        await authDataSource.login(context, email: email, password: password);
  }

  Future<void> editAccount(
    BuildContext context, {
    required String email,
    required String name,
  }) async {
    await authDataSource.editAccount(context, email: email, name: name);
  }

  Future<bool> deleteAccount(BuildContext context) async {
    return await authDataSource.deleteAccount(context);
  }

  Future<bool> register(
    BuildContext context, {
    required String displayName,
    required String email,
    required String password,
  }) async {
    return await authDataSource.register(context,
        displayName: displayName, email: email, password: password);
  }

  Future<bool> sendOtpCode(BuildContext context, {String? email}) async {
    print(AppConstants.email);
    return await authDataSource.sendOtpCode(context);
  }

  Future<bool> resetPassword(BuildContext context,
      {required String password, required String verificationCode}) async {
    print(AppConstants.email);
    return await authDataSource.sendOtpCode(context);
  }

  void onRemember(bool value) {
    isRemembered = value;
    rememberNotifier.value = isRemembered;
  }

  void onObsecured(bool value) {
    isObsecurd = value;
    obsecuredNotifier.value = isObsecurd;
  }
}
