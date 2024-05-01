import 'package:bath_room_app/core/network/app_constants.dart';
import 'package:bath_room_app/models/locations_model/location_model.dart';
import 'package:flutter/material.dart';

import '../../../core/colors/colours.dart';
import '../../widgets/rating_widget.dart';

class LocationInfoContainer extends StatelessWidget {
  final LocationModel locationModel;

  const LocationInfoContainer({super.key, required this.locationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: locationModel.instantCoffee == false
            ? ConstantsColors.navigationColor2
            : ConstantsColors.fillColor3,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coffee type:",
              style: TextStyle(
                  color: locationModel.instantCoffee == false
                      ? ConstantsColors.bottomSheetBackGround
                      : ConstantsColors.navigationColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      locationModel.instantCoffee == true
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: locationModel.instantCoffee == false
                          ? ConstantsColors.bottomSheetBackGround
                          : ConstantsColors.navigationColor2,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Instant coffee",
                      style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      locationModel.instantCoffee == true
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: locationModel.instantCoffee == false
                          ? ConstantsColors.bottomSheetBackGround
                          : ConstantsColors.navigationColor2,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Ground coffee",
                      style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
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
                Icon(
                  locationModel.alternateOptions == true
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  color: locationModel.instantCoffee == false
                      ? ConstantsColors.bottomSheetBackGround
                      : ConstantsColors.navigationColor2,
                ),
                const SizedBox(width: 5),
                Text(
                  "Alternative options",
                  style: TextStyle(
                      color: locationModel.instantCoffee == false
                          ? ConstantsColors.bottomSheetBackGround
                          : ConstantsColors.navigationColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Rating:",
              style: TextStyle(
                  color: locationModel.instantCoffee == false
                      ? ConstantsColors.bottomSheetBackGround
                      : ConstantsColors.navigationColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Price:",
                        style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ...buildRatingImages(
                        rating: locationModel.priceRating!.toDouble(),
                        ratingAssetPath: locationModel.instantCoffee == false
                            ? AppConstants.image5
                            : AppConstants.image4,
                        ratingRemainPath: locationModel.instantCoffee == false
                            ? AppConstants.image4
                            : AppConstants.image5,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Taste:",
                        style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...buildRatingImages(
                        rating: locationModel.tasteRating!.toDouble(),
                        ratingAssetPath: locationModel.instantCoffee == false
                            ? AppConstants.image5
                            : AppConstants.image4,
                        ratingRemainPath: locationModel.instantCoffee == false
                            ? AppConstants.image4
                            : AppConstants.image5,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Selection:",
                        style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...buildRatingImages(
                        rating: locationModel.selectionRating!.toDouble(),
                        ratingAssetPath: locationModel.instantCoffee == false
                            ? AppConstants.image5
                            : AppConstants.image4,
                        ratingRemainPath: locationModel.instantCoffee == false
                            ? AppConstants.image4
                            : AppConstants.image5,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Friendliness:",
                        style: TextStyle(
                          color: locationModel.instantCoffee == false
                              ? ConstantsColors.bottomSheetBackGround
                              : ConstantsColors.navigationColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...buildRatingImages(
                        rating: locationModel.friendlinessRating!.toDouble(),
                        ratingAssetPath: locationModel.instantCoffee == false
                            ? AppConstants.image5
                            : AppConstants.image4,
                        ratingRemainPath: locationModel.instantCoffee == false
                            ? AppConstants.image4
                            : AppConstants.image5,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
