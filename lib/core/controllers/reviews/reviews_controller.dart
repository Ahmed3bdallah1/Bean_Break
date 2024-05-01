import 'package:bath_room_app/core/network/remote/api_service.dart';
import 'package:bath_room_app/models/review_models/review_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../presantion/widgets/snak_bar.dart';
import '../../network/app_constants.dart';

class RatingModel {
  final String key;
  final String uiString;
  double rating;

  RatingModel({required this.key, this.rating = 0, required this.uiString});
}

class BoolRatingModel {
  final String key;
  final String uiString;
  bool rating;

  BoolRatingModel(
      {required this.key, this.rating = false, required this.uiString});
}

class ReviewsController extends ChangeNotifier {
  final ApiService apiService;

  ReviewsController({required this.apiService});

  List<ReviewModel> _reviewsList = [];
  bool isLoading = false;

  static final ValueNotifier<List<ReviewModel>> reviewsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<ReviewModel>> myReviewsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<ReviewModel>> locationReviewsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<Map<String, dynamic>> reviewsValuesNotifier =
      ValueNotifier({});

  // bool instantCoffee = false;
  // bool groundCoffee = false;
  // bool alternativeOptions = false;
  // bool sitDown = false;
  // bool keyRequired = false;
  // bool wheelchairFriendly = false;
  List<RatingModel> ratings = [
    RatingModel(key: 'price_rating', uiString: 'price:'),
    RatingModel(key: 'taste_rating', uiString: 'taste:'),
    RatingModel(key: 'selection_rating', uiString: 'selection:'),
    RatingModel(key: 'friendliness_rating', uiString: 'friendliness:'),
    RatingModel(key: 'cleanliness_rating', uiString: 'cleanliness:'),
    RatingModel(key: 'accessibility_rating', uiString: 'accessibility:'),
    RatingModel(key: 'supplies_rating', uiString: 'supplies:'),
    RatingModel(key: 'safety_rating', uiString: 'safety:'),
  ];
  List<BoolRatingModel> boolRatings = [
    BoolRatingModel(key: 'instant_coffee', uiString: 'Instant coffee'),
    BoolRatingModel(key: 'beans_coffee', uiString: 'Ground coffee'),
    BoolRatingModel(key: 'alternate_options', uiString: 'Alternate options'),
    BoolRatingModel(key: 'sit_down', uiString: 'Sit down'),
    BoolRatingModel(key: 'key_required', uiString: 'Key required'),
    BoolRatingModel(key: 'wheelchair_friendly', uiString: 'Wheelchair friendly'),
    BoolRatingModel(key: 'is_free', uiString: 'Is free'),
  ];

  reset() {
    // instantCoffee = false;
    // groundCoffee = false;
    // alternativeOptions = false;
    // sitDown = false;
    // keyRequired = false;
    // wheelchairFriendly = false;
    ratings = [
      RatingModel(key: 'price_rating', uiString: 'price:'),
      RatingModel(key: 'taste_rating', uiString: 'taste:'),
      RatingModel(key: 'selection_rating', uiString: 'selection:'),
      RatingModel(key: 'friendliness_rating', uiString: 'friendliness:'),
      RatingModel(key: 'cleanliness_rating', uiString: 'cleanliness:'),
      RatingModel(key: 'accessibility_rating', uiString: 'accessibility:'),
      RatingModel(key: 'supplies_rating', uiString: 'supplies:'),
      RatingModel(key: 'safety_rating', uiString: 'safety:'),
    ];
    boolRatings = [
      BoolRatingModel(key: 'instant_coffee', uiString: 'Instant coffee'),
      BoolRatingModel(key: 'beans_coffee', uiString: 'Ground coffee'),
      BoolRatingModel(key: 'alternate_options', uiString: 'Alternate options'),
      BoolRatingModel(key: 'sit_down', uiString: 'Sit down'),
      BoolRatingModel(key: 'key_required', uiString: 'Key required'),
      BoolRatingModel(key: 'wheelchair_friendly', uiString: 'Wheelchair friendly'),
      BoolRatingModel(key: 'is_free', uiString: 'Is free'),
    ];
    notifyListeners();
  }

  setRating(int index, double rate) {
    ratings[index].rating = rate;
    notifyListeners();
  }

  setBoolRating(int index, bool bool) {
    boolRatings[index].rating = bool;
    notifyListeners();
  }

  // Future<List<ReviewModel>?> getAllReviews(BuildContext context) async {
  //   try {
  //     final res = await apiService.get(url: AppConstants.GET_ALL_REVIEWS);
  //     List<dynamic> data = res;
  //     _reviewsList = data.map((e) {
  //       return ReviewModel.fromJson(e);
  //     }).toList();
  //     reviewsNotifier.value = _reviewsList;
  //     print("==========>${reviewsNotifier.value.length}");
  //     return reviewsNotifier.value;
  //   } catch (e) {
  //     if (e is DioException) {
  //       if (e.response!.statusCode == 500) {
  //         showSnackBar(context, text: e.response.toString(), color: Colors.red);
  //       }
  //       showSnackBar(context, text: e.message!, color: Colors.red);
  //       return [];
  //     } else {
  //       showSnackBar(context, text: e.toString(), color: Colors.red);
  //       return [];
  //     }
  //   }
  // }

  Future<List<ReviewModel>> getLocationReviews(BuildContext context,
      {required String locationId}) async {
    try {
      final res = await apiService.get(
        url: "${AppConstants.GET_LOCATION_REVIEWS}/$locationId",
      );
      List<dynamic> data = res;
      locationReviewsNotifier.value = data.map((e) {
        return ReviewModel.fromJson(e);
      }).toList();
      return locationReviewsNotifier.value;
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

  Future<bool> deleteReview(BuildContext context,
      {required String locationId}) async {
    try {
      var response = await apiService.delData(
          url: "${AppConstants.DELETE_REVIEW}/$locationId");
      print('Delete API response: $response');

      var currentReviews = List<ReviewModel>.from(myReviewsNotifier.value);
      currentReviews.removeWhere((review) => review.id == locationId);
      myReviewsNotifier.value = currentReviews;
      if (response.statusCode == 200) {
        showSnackBar(context,
            text: "Review has been deleted", color: Colors.green);
      }
      print('New notifier length: ${myReviewsNotifier.value.length}');

      return true;
    } catch (e) {
      print("===============error=============");
      print("=========== ${e.toString()}");
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

  Future<List<ReviewModel>?> getMyReviews(BuildContext context) async {
    print("object");
    try {
      final res = await apiService.get(
          url: "${AppConstants.GET_MY_REVIEWS}${AppConstants.userId}");
      List<dynamic> data = res;
      _reviewsList = data.map((e) {
        return ReviewModel.fromJson(e);
      }).toList();
      myReviewsNotifier.value = _reviewsList;
      print("==========>${myReviewsNotifier.value.length}");
      return myReviewsNotifier.value;
    } catch (e) {
      print("=============error===========");
      print(e.toString());
      return [];
    }
  }
}
