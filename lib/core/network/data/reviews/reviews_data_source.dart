import 'package:beak_break/core/network/remote/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../models/review_models/review_model.dart';
import '../../../../presantion/widgets/snak_bar.dart';
import '../../app_constants.dart';

abstract class ReviewsDataSource {
  Future<List<ReviewModel>> getLocationReviews(BuildContext context,
      {required String locationId});

  // Future<List<LocationModel>?> getAllFavorites(BuildContext context);

  Future<bool> addReview(BuildContext context,
      {required Map<String, dynamic> map});


  Future<List<ReviewModel>?> getMyReviews(BuildContext context);
}


class ReviewsDataSourceImp extends ReviewsDataSource{
  final ApiService apiService;

  ReviewsDataSourceImp({required this.apiService});

  @override
  Future<List<ReviewModel>> getLocationReviews(BuildContext context,
      {required String locationId}) async {
    try {
      final res = await apiService.get(
        url: "${AppConstants.GET_LOCATION_REVIEWS}/$locationId",
      );
      List<dynamic> data = res;
      final list = data.map((e) {
        return ReviewModel.fromJson(e);
      }).toList();
      return list;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(context, text: e.message!, color: Colors.red);
        return [];
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
        return [];
      }
    }
  }


  @override
  Future<bool> addReview(BuildContext context,
      {required Map<String, dynamic> map}) async {
    try {
      await apiService.post(
          url: AppConstants.ADD_REVIEW,
          requestBody: map,
          additionalHeaders: {"api_token": AppConstants.token});
      await getMyReviews(context);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        showSnackBar(
          context,
          text: ServerFailure.getMessage(e.response!.statusCode) ??
              "something went wrong, please try again later",
          color: Colors.red,
        );
        return false;
      } else {
        showSnackBar(context,
            text: "something went wrong, please try again later",
            color: Colors.red);
        return false;
      }
    }
  }


  @override
  Future<List<ReviewModel>?> getMyReviews(BuildContext context) async {
    print("object");
    try {
      final res = await apiService.get(
          url: "${AppConstants.GET_MY_REVIEWS}${AppConstants.userId}");
      List<dynamic> data = res;
      final list = data.map((e) {
        return ReviewModel.fromJson(e);
      }).toList();
      print("==========>${list.length}");
      return list;
    } catch (e) {
      print("=============error===========");
      print(e.toString());
      return [];
    }
  }
}