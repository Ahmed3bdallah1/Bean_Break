import 'dart:async';
import 'package:bath_room_app/core/controllers/location/location_controller.dart';
import 'package:bath_room_app/core/network/app_constants.dart';
import 'package:bath_room_app/presantion/maps/add_to_map_screen.dart';
import 'package:bath_room_app/presantion/maps/widgets/location_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/validators/bitmap_asset.dart';
import '../../models/locations_model/location_model.dart';

class MapsScreen extends StatefulWidget {
  final List<LocationModel> locations;
  final LocationModel? locationModel;
  final CameraPosition? cameraPosition;

  const MapsScreen(
      {super.key,
      required this.locations,
      this.locationModel,
      this.cameraPosition});

  @override
  State<MapsScreen> createState() => MapsScreenState();
}

class MapsScreenState extends State<MapsScreen> {
  BitmapDescriptor? cafeIcon;
  BitmapDescriptor? bathroomIcon;
  BitmapDescriptor? bothIcon;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  late final LatLng latlng;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(-32.2223, 28.888),
    zoom: 15.4746,
  );

  @override
  void initState() {
    super.initState();
    getImageMarker();
    //
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (widget.locationModel != null) {
    //     showLocationDetails(
    //       context,
    //       location: widget.locationModel!,
    //       isCafe: widget.locationModel!.instantCoffee ?? false,
    //     );
    //   }
    // });
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
          infoWindow: InfoWindow(
              title: location.name, snippet: location.locationDescription),
          onTap: () {
            showLocationDetails(
              context,
              location: location,
              isCafe: location.instantCoffee == true,
              isBathroom: location.alternateOptions ?? false,
            );
          });
    }).toSet();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Consumer<LocationController>(
            builder: (context, controller, _) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class InitialMapsScreen extends StatefulWidget {
  final bool addLocation;

  const InitialMapsScreen({super.key, required this.addLocation});

  @override
  State<InitialMapsScreen> createState() => _InitialMapsScreenState();
}

class _InitialMapsScreenState extends State<InitialMapsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<LocationModel>>(
      valueListenable: LocationController.locationsNotifier,
      builder: (context, locations, _) {
        if (widget.addLocation == false) {
          return MapsScreen(locations: locations);
        } else {
          return AddToMapScreen(
            locations: locations,
          );
        }
      },
    );
  }
}
