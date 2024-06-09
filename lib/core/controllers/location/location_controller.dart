import 'package:beak_break/models/locations_model/location_model.dart';
import 'package:beak_break/presantion/widgets/snak_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../network/app_constants.dart';
import '../../network/data/location_data_source/location_data_source.dart';
import '../../network/remote/api_service.dart';

class LocationController extends ChangeNotifier {
  final ApiService apiService;
  final LocationDataSource locationDataSource;

  LocationController({
    required this.apiService,
    required this.locationDataSource,
  });

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
    _locationsList = await locationDataSource.getAllLocations(context) ?? [];
    locationsNotifier.value = _locationsList;
    return locationsNotifier.value;
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
    final added = await locationDataSource.addToFavorites(context,
        locationId: locationId);
    if (added) {
      final location =
          locationsList.firstWhere((element) => element.id == locationId);
      myFavoritesNotifier.value.add(location);
      notifyListeners();
    }
    return added;
  }

  Future<bool> removeFromFavorites(BuildContext context,
      {required String locationId}) async {
    final removed = await locationDataSource.removeFromFavorites(context,
        locationId: locationId);
    if (removed) {
      final location =
          locationsList.firstWhere((element) => element.id == locationId);
      myFavoritesNotifier.value.remove(location);
      notifyListeners();
    }
    return removed;
  }

  List<LocationModel> get locationsList => _locationsList;

  List<LocationModel> get favoritesList => _favoritesList;

  Future<LocationModel?> getLocation(BuildContext context,
          {required String locationId}) async =>
      await locationDataSource.getLocation(context, locationId: locationId);

  Future<void> addLocation(BuildContext context,
          {required Map<String, dynamic> map}) async =>
      await locationDataSource.addLocation(context, map: map);

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
