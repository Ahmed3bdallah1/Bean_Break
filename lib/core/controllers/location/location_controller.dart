import 'package:bath_room_app/models/locations_model/location_model.dart';
import 'package:bath_room_app/presantion/widgets/snak_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../network/app_constants.dart';
import '../../network/remote/api_service.dart';

class LocationController extends ChangeNotifier {
  final ApiService apiService;

  LocationController({required this.apiService});

  List<LocationModel> _locationsList = [];
  List<LocationModel> _favoritesList = [];
  static final ValueNotifier<List<LocationModel>> locationsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<LocationModel>> myFavoritesNotifier =
      ValueNotifier([]);
  static final ValueNotifier<bool> closedNotifier = ValueNotifier(false);

  bool instantCoffeeSelected = false;
  bool groundCoffeeSelected = false;
  bool alternativeOptionsSelected = false;
  bool isBannerAdReady = false;
  double cleanlinessRating = 0.0;
  double accessibilityRating = 0.0;
  double suppliesRating = 0.0;
  double safetyRating = 0.0;
  double priceRating = 0.0;
  double tasteRating = 0.0;
  double selectionRating = 0.0;
  double friendlinessRating = 0.0;

  static final ValueNotifier<Map<String, bool>> boolValuesNotifier =
      ValueNotifier({});

  Future<List<LocationModel>?> getAllLocations(BuildContext context) async {
    try {
      final res = await apiService.get(url: AppConstants.GET_ALL_LOCATIONS);
      List<dynamic> data = res;
      _locationsList = data.map((e) {
        return LocationModel.fromJson(e);
      }).toList();
      locationsNotifier.value = _locationsList;
      return _locationsList;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        return null;
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
        return null;
      }
    }
  }

  Future<List<LocationModel>?> getAllFavorites(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final res = await apiService.get(
        url: "${AppConstants.GET_MY_FAVORITES}${AppConstants.userId}",
      );
      List<dynamic> data = res;

      final List<LocationModel> list = [];

      for (var id in data) {
        print(id.toString());
        final location =
            locationsList.firstWhere((element) => element.id == id.toString());
        list.add(location);
        print(id);
        print(location);
      }

      _favoritesList = list;
      myFavoritesNotifier.value = _favoritesList;
      return myFavoritesNotifier.value;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(context, text: e.response.toString(), color: Colors.red);
        }
        return null;
      } else {
        showSnackBar(context, text: e.toString(), color: Colors.red);
        return null;
      }
    }
  }

  Future<bool> addToFavorites(BuildContext context,
      {required String locationId}) async {
    try {
      final res = await apiService.post(
        url: "${AppConstants.ADD_TO_FAVORITES}$locationId",
        additionalHeaders: {"api_token": AppConstants.token},
      );

      showSnackBar(
        context,
        text: "location added to favorites successfully",
        color: Colors.green,
      );

      final location =
          locationsList.firstWhere((element) => element.id == locationId);
      myFavoritesNotifier.value.add(location);
      notifyListeners();
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

  Future<bool> removeFromFavorites(BuildContext context,
      {required String locationId}) async {
    try {
      await apiService.post(
        url: "${AppConstants.DELETE_FAVORITE}$locationId",
        additionalHeaders: {"api_token": AppConstants.token},
      );

      showSnackBar(
        context,
        text: "location removed from favorites successfully",
        color: Colors.green,
      );
      final location =
          locationsList.firstWhere((element) => element.id == locationId);
      myFavoritesNotifier.value.remove(location);
      notifyListeners();

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

  List<LocationModel> get locationsList => _locationsList;

  List<LocationModel> get favoritesList => _favoritesList;

  Future<LocationModel?> getLocation(BuildContext context,
      {required String locationId}) async {
    try {
      final res =
          await apiService.get(url: "${AppConstants.GET_LOCATION}/$locationId");

      LocationModel locationModel = LocationModel.fromJson(res["data"]);
      return locationModel;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          showSnackBar(
            context,
            text: e.response.toString(),
            color: Colors.red,
          );
        }
        return null;
      } else {
        showSnackBar(
          context,
          text: "something went wrong, please try again later",
          color: Colors.red,
        );
        return null;
      }
    }
  }

  Future<void> addLocation(BuildContext context,
      {required Map<String, dynamic> map}) async {
    try {
      await apiService.post(
        url: AppConstants.ADD_LOCATION,
        additionalHeaders: {"api_token": AppConstants.token},
        requestBody: map,
      );
      Navigator.pop(context);
      showSnackBar(context,
          text:
              "location added successfully, please restart the app to see your place",
          color: Colors.green,
          duration: const Duration(seconds: 8));
      // notifyListeners();
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
      } else {
        showSnackBar(context,
            text: "something went wrong, please try again later",
            color: Colors.red);
      }
    }
  }

  void close(bool value) {
    closedNotifier.value = value;
  }

  void handleInstantCoffeeSelected(bool value) {
    instantCoffeeSelected = value;
    boolValuesNotifier.value.addAll({"instant_coffee": instantCoffeeSelected});
    notifyListeners();
  }

  void handleGroundCoffeeSelected(bool value) {
    groundCoffeeSelected = value;
    boolValuesNotifier.value.addAll({"ground_coffee": groundCoffeeSelected});
    notifyListeners();
  }

  void handleAlternativeOptionsSelected(bool value) {
    alternativeOptionsSelected = value;
    boolValuesNotifier.value
        .addAll({"alternative_options": alternativeOptionsSelected});
    notifyListeners();
  }

  bool checkFavorite({required String locationId}) {
    final x = _favoritesList.where((favorite) => favorite.id == locationId);
    return x.isNotEmpty;
  }
}
