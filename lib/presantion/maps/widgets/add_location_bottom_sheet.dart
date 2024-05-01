import 'package:bath_room_app/core/controllers/location/location_controller.dart';
import 'package:bath_room_app/core/validators/vaildation.dart';
import 'package:bath_room_app/presantion/widgets/custom_button.dart';
import 'package:bath_room_app/presantion/widgets/custoum_text_filed.dart';
import 'package:bath_room_app/presantion/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/colors/colours.dart';

Future<String?> geo(LatLng latLng) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];
    String address = '${place.locality}, ${place.country}';
    print(address);
    return address;
  } catch (e) {
    return null;
  }
}

void showAddLocationDetails(BuildContext context, LatLng latLng) {
  Size size = MediaQuery.of(context).size;
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: .8,
    backgroundColor: ConstantsColors.bottomSheetBackGround,
    context: context,
    builder: (context) {
      final key = GlobalKey<FormState>();
      return SizedBox(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    "Add New Location",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ConstantsColors.navigationColor2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                        controller: nameController,
                        validator: validateName,
                        prefixIcon: Icons.add_business_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                        maxLines: 2,
                        controller: desController,
                        prefixIcon: Icons.add_location_alt),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ConstantsColors.navigationColor2,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 18),
                        child: Consumer<LocationController>(
                          builder: (context, controller, _) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Coffee type:",
                                  style: TextStyle(
                                      color:
                                          ConstantsColors.bottomSheetBackGround,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .handleInstantCoffeeSelected(
                                                    !controller
                                                        .instantCoffeeSelected);
                                          },
                                          child: Icon(
                                            controller.instantCoffeeSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: ConstantsColors
                                                .bottomSheetBackGround,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "instant coffee",
                                          style: TextStyle(
                                              color: ConstantsColors
                                                  .bottomSheetBackGround,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .handleGroundCoffeeSelected(
                                                    !controller
                                                        .groundCoffeeSelected);
                                          },
                                          child: Icon(
                                            controller.groundCoffeeSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: ConstantsColors
                                                .bottomSheetBackGround,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Ground coffee",
                                          style: TextStyle(
                                              color: ConstantsColors
                                                  .bottomSheetBackGround,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller
                                            .handleAlternativeOptionsSelected(
                                                !controller
                                                    .alternativeOptionsSelected);
                                      },
                                      child: Icon(
                                        controller.alternativeOptionsSelected
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: ConstantsColors
                                            .bottomSheetBackGround,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Alternative options",
                                      style: TextStyle(
                                          color: ConstantsColors
                                              .bottomSheetBackGround,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Rating:",
                                  style: TextStyle(
                                      color:
                                          ConstantsColors.bottomSheetBackGround,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                AddRatingIndex(
                                  index: Provider.of<LocationController>(
                                          context,
                                          listen: false)
                                      .priceRating,
                                  onChanged: (value) {
                                    Provider.of<LocationController>(context,
                                            listen: false)
                                        .priceRating = value;
                                  },
                                  title: "Price:",
                                  color: ConstantsColors.bottomSheetBackGround,
                                ),
                                AddRatingIndex(
                                  index: Provider.of<LocationController>(
                                          context,
                                          listen: false)
                                      .tasteRating,
                                  onChanged: (value) {
                                    Provider.of<LocationController>(context,
                                            listen: false)
                                        .tasteRating = value;
                                  },
                                  title: "Taste:",
                                  color: ConstantsColors.bottomSheetBackGround,
                                ),
                                AddRatingIndex(
                                  index: Provider.of<LocationController>(
                                          context,
                                          listen: false)
                                      .selectionRating,
                                  onChanged: (value) {
                                    Provider.of<LocationController>(context,
                                            listen: false)
                                        .selectionRating = value;
                                  },
                                  title: "Selection:",
                                  color: ConstantsColors.bottomSheetBackGround,
                                ),
                                AddRatingIndex(
                                  index: Provider.of<LocationController>(
                                          context,
                                          listen: false)
                                      .friendlinessRating,
                                  onChanged: (value) {
                                    Provider.of<LocationController>(context,
                                            listen: false)
                                        .friendlinessRating = value;

                                    print(Provider.of<LocationController>(
                                            context,
                                            listen: false)
                                        .friendlinessRating);
                                  },
                                  title: "Friendliness:",
                                  color: ConstantsColors.bottomSheetBackGround,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Consumer<LocationController>(
                    builder: (context, controller, _) {
                      return ValueListenableBuilder<Map<String, bool>>(
                          valueListenable:
                              LocationController.boolValuesNotifier,
                          builder: (context, entity, _) {
                            return CustomButton(
                              text: "Add Location",
                              width: size.width * .5,
                              onPressed: () async {
                                final address = await geo(latLng);
                                if (key.currentState!.validate()==true) {
                                  key.currentState!.save();
                                  await controller.addLocation(
                                    context,
                                    map: {
                                      "name": nameController.text,
                                      "latitude": latLng.latitude,
                                      "longitude": latLng.longitude,
                                      "location_description": address,
                                      "description": desController.text,
                                      "instant_coffee":
                                      entity["instant_coffee"] ?? false,
                                      "ground_coffee":
                                      entity["ground_coffee"] ?? false,
                                      "alternate_options":
                                      entity["alternative_options"] ?? false,
                                      "price_rating": controller.priceRating,
                                      "taste_rating": controller.tasteRating,
                                      "selection_rating":
                                      controller.selectionRating,
                                      "friendliness_rating":
                                      controller.friendlinessRating,
                                    },
                                  );
                                }

                              },
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
