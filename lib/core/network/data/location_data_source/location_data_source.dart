import 'package:beak_break/core/network/remote/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../models/locations_model/location_model.dart';
import '../../../../presantion/widgets/snak_bar.dart';
import '../../app_constants.dart';

abstract class LocationDataSource {
  Future<List<LocationModel>?> getAllLocations(BuildContext context);

  // Future<List<LocationModel>?> getAllFavorites(BuildContext context);

  Future<bool> addToFavorites(BuildContext context,
      {required String locationId});

  Future<bool> removeFromFavorites(BuildContext context,
      {required String locationId});

  Future<LocationModel?> getLocation(BuildContext context,
      {required String locationId});

  Future<void> addLocation(BuildContext context,
      {required Map<String, dynamic> map});
}

class LocationDataSourceImp extends LocationDataSource {
  final ApiService apiService;

  LocationDataSourceImp({required this.apiService});


  @override
  Future<List<LocationModel>?> getAllLocations(BuildContext context) async {
    try {
      final res = await apiService.get(url: AppConstants.GET_ALL_LOCATIONS);
      List<dynamic> data = res;
      final locationsList = data.map((e) {
        return LocationModel.fromJson(e);
      }).toList();
      return locationsList;
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


  @override
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

  @override
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

  @override
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

  // @override
  // Future<List<LocationModel>?> getAllFavorites(BuildContext context) {
  //   // TODO: implement getAllFavorites
  //   throw UnimplementedError();
  // }

  @override
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
}
