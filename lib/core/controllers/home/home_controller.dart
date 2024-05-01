import 'package:bath_room_app/core/network/remote/api_service.dart';
import 'package:bath_room_app/presantion/home/home_screen.dart';
import 'package:bath_room_app/presantion/maps/maps_screen.dart';
import 'package:bath_room_app/presantion/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/locations_model/location_model.dart';

class HomeController extends ChangeNotifier {
  final ApiService apiService;

  HomeController({required this.apiService});

  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    InitialMapsScreen(
      addLocation: false,
    ),
    ProfileScreen(),
    InitialMapsScreen(
      addLocation: true,
    ),
  ];

  void changeNavigation(int index) {
    currentIndex = index;
    notifyListeners();
  }

  LocationModel? selectedLocation;

  void navigateToMapWithLocation(LocationModel locationModel) {
    selectedLocation = locationModel;
    currentIndex = 1;
    notifyListeners();
  }
}
