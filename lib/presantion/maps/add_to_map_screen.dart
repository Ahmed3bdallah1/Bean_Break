import 'dart:async';
import 'package:bath_room_app/core/colors/colours.dart';
import 'package:bath_room_app/core/validators/bitmap_asset.dart';
import 'package:bath_room_app/models/locations_model/location_model.dart';
import 'package:bath_room_app/presantion/maps/widgets/add_location_bottom_sheet.dart';
import 'package:bath_room_app/presantion/maps/widgets/location_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/controllers/location/location_controller.dart';
import '../../core/network/app_constants.dart';
import '../../core/routing/router.dart';
import '../widgets/custom_show_dialog.dart';

class AddToMapScreen extends StatefulWidget {
  final List<LocationModel> locations;

  const AddToMapScreen({super.key, required this.locations});

  @override
  State<AddToMapScreen> createState() => _AddToMapScreenState();
}

class _AddToMapScreenState extends State<AddToMapScreen> {
  BitmapDescriptor? cafeIcon;
  BitmapDescriptor? bathroomIcon;
  BitmapDescriptor? bothIcon;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-32.2223, 28.888),
    zoom: 15.4746,
  );

  @override
  void initState() {
    super.initState();
    getImageMarker();
  }

  getImageMarker() async {
    cafeIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset(AppConstants.image2, 160),
    );
    bathroomIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset(AppConstants.image1, 160),
    );
    bothIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset(AppConstants.image3, 160),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = widget.locations.map((location) {
      final icon =
          location.instantCoffee == true && location.alternateOptions == true
              ? bothIcon
              : location.instantCoffee == true
                  ? cafeIcon
                  : bathroomIcon;
      return Marker(
          markerId: MarkerId(location.id ?? "default_id"),
          position: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
          icon: icon ?? BitmapDescriptor.defaultMarker,
          infoWindow:
              InfoWindow(title: location.name, snippet: location.description),
          onTap: () {
            showLocationDetails(
              context,
              location: location,
              isCafe: location.instantCoffee ?? false,
              isBathroom: location.alternateOptions ?? false,
            );
          });
    }).toSet();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onLongPress: (latLog) {
              if (AppConstants.token != '') {
                showAddLocationDetails(context, latLog);
              } else {
                showCustomDialog(
                  context,
                  title: "Unauthorized",
                  body: "please login to access the add location feature",
                  actionName: "login",
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            left: 20,
            child: ValueListenableBuilder<bool>(
              valueListenable: LocationController.closedNotifier,
              builder: (context, isClosed, _) {
                return isClosed == false
                    ? Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color:
                                ConstantsColors.navigationColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Row(
                            children: [
                              const Text(
                                "Tap and hold to select location",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              const Spacer(),
                              Consumer<LocationController>(
                                builder: (context, controller, _) {
                                  return InkWell(
                                    onTap: () {
                                      controller.close(true);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
