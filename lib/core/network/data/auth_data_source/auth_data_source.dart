import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/user_models/all_users_model.dart';
import '../../../../models/user_models/user_model.dart';
import '../../../../presantion/home/widgets/navigation.dart';
import '../../../../presantion/widgets/snak_bar.dart';
import '../../../colors/colours.dart';
import '../../app_constants.dart';
import '../../local/cache_helper.dart';
import '../../remote/api_service.dart';

abstract class AuthDataSource {
  Future<List<AllUsersData>?> allUsers();

  Future<UserModel?> login(
    BuildContext context, {
    required String email,
    required String password,
    bool? remember,
  });

  Future<bool> register(
    BuildContext context, {
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> editAccount(
    BuildContext context, {
    required String email,
    required String name,
  });

  Future<bool> deleteAccount(BuildContext context);

  Future<bool> sendOtpCode(BuildContext context, {String? email});

  Future<bool> resetPassword(BuildContext context,
      {required String password, required String verificationCode});
}

class AuthDataSourceImp extends AuthDataSource {
  final CacheHelper cacheHelper;
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  AuthDataSourceImp(
      {required this.cacheHelper,
      required this.sharedPreferences,
      required this.apiService});

  @override
  Future<List<AllUsersData>?> allUsers() async {
    try {
      final res = await apiService.get(url: AppConstants.GET_USERS);
      List<dynamic> list = res;

      return list.map((e) {
        return AllUsersData.fromJson(e);
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> deleteAccount(BuildContext context) async {
    try {
      await apiService.delData(
          url: '${AppConstants.DELETE_ACCOUNT}${AppConstants.userId}');
      showSnackBar(
        context,
        color: Colors.green,
        text: "Account deleted successfully",
      );
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context,
              text: "something went wrong", color: Colors.red);
        }
        showSnackBar(context,
            text: e.message ?? "something went wrong", color: Colors.red);
      } else {
        showSnackBar(context, text: "something went wrong", color: Colors.red);
      }
      return false;
    }
  }

  @override
  Future<void> editAccount(BuildContext context,
      {required String email, required String name}) async {
    try {
      await apiService.put(url: AppConstants.ADD_EDIT_ACCOUNT, requestBody: {
        "id": AppConstants.userId,
        "email": email,
        "display_name": name,
      });
      showSnackBar(
        context,
        color: Colors.green,
        text:
            "profile edited successfully, your password has been reset empty , please make sure to reset password ",
        duration: const Duration(seconds: 10),
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(context,
            text: e.message ?? "something went wrong", color: Colors.red);
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
      }
    }
  }

  @override
  Future<UserModel?> login(BuildContext context,
      {required String email, required String password, bool? remember}) async {
    try {
      final res =
          await apiService.post(url: AppConstants.VERIFYLOGIN, requestBody: {
        "email": email,
        "password": password,
      });
      final userModel = UserModel.fromJson(res);
      if (userModel.token != null) {
        showSnackBar(context,
            text: "Welcome ${userModel.displayName}",
            color: ConstantsColors.navigationColor);
        cacheHelper.saveData(key: "userId", value: userModel.id ?? '').then(
          (value) {
            AppConstants.userId = userModel.id ?? '';
          },
        );
        cacheHelper.saveData(key: "email", value: userModel.email ?? '').then(
          (value) {
            AppConstants.email = userModel.email ?? '';
          },
        );
        cacheHelper
            .saveData(key: "name", value: userModel.displayName ?? '')
            .then(
          (value) {
            AppConstants.name = userModel.displayName ?? '';
          },
        );
        if (remember == true) {
          cacheHelper.saveData(key: "token", value: userModel.token ?? '').then(
            (value) {
              AppConstants.token = userModel.token ?? '';
            },
          );
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationBarConfig()),
            (route) => false);
      }
      return userModel;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(context,
            text: e.response!.data.toString().isEmpty
                ? "user not found"
                : "something went wrong",
            color: Colors.red);
        return null;
      } else {
        showSnackBar(context,
            text: "user not found or password may not correct",
            color: Colors.red);
        return null;
      }
    }
  }

  @override
  Future<bool> register(BuildContext context,
      {required String displayName,
      required String email,
      required String password}) async {
    try {
      final res = await apiService
          .post(url: AppConstants.ADD_EDIT_ACCOUNT, requestBody: {
        "email": email,
        "display_name": displayName,
        "password": password,
      });
      showSnackBar(
        context,
        color: Colors.green,
        text:
            "Account created successfully, please check your email to verify your account",
        duration: const Duration(seconds: 10),
      );
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context,
              text: ServerFailure.getMessage(e.response!.statusCode) ?? "",
              color: Colors.red);
        }
        print(e);
        showSnackBar(context,
            text: ServerFailure.getMessage(e.response!.statusCode) ??
                "something went wrong",
            color: Colors.red,
            duration: const Duration(seconds: 10));
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
      }
      return false;
    }
  }

  @override
  Future<bool> resetPassword(BuildContext context,
      {required String password, required String verificationCode}) async {
    try {
      await apiService.post(
        url: AppConstants.RESET_OR_SUBMIT_PASSWORD_EMAIL,
        requestBody: {
          "email": AppConstants.email,
          "new_password": password,
          "reset_code": verificationCode
        },
      );
      showSnackBar(context,
          text: "your password changed successfully", color: Colors.green);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(context,
            text: e.message ?? "something went wrong",
            color: Colors.red,
            duration: const Duration(seconds: 10));
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
      }
      return false;
    }
  }

  @override
  Future<bool> sendOtpCode(BuildContext context, {String? email}) async {
    try {
      await apiService.getData(
        url: AppConstants.RESET_OR_SUBMIT_PASSWORD_EMAIL,
        data: {
          "email": email ?? AppConstants.email,
        },
      );
      showSnackBar(context,
          text: "otp send please check your email", color: Colors.green);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(context,
            text: e.message ?? "something went wrong",
            color: Colors.red,
            duration: const Duration(seconds: 10));
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
      }
      return false;
    }
  }
}
