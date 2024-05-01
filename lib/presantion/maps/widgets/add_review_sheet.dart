import 'dart:async';

import 'package:beak_break/core/controllers/reviews/reviews_controller.dart';
import 'package:beak_break/core/network/app_constants.dart';
import 'package:beak_break/models/locations_model/location_model.dart';
import 'package:beak_break/presantion/widgets/rating_widget.dart';
import 'package:beak_break/presantion/widgets/snak_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/colors/colours.dart';
import '../../widgets/custom_button.dart';

Future<void> showAddReviewDetails(
    BuildContext context, LocationModel locationModel) async {
  Size size = MediaQuery.of(context).size;
  await showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: .68,
    backgroundColor: ConstantsColors.bottomSheetBackGround,
    context: context,
    builder: (context) {
      return SizedBox(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      locationModel.instantCoffee == true &&
                              locationModel.alternateOptions == true
                          ? AppConstants.image3
                          : locationModel.instantCoffee == true
                              ? AppConstants.image2
                              : AppConstants.image1,
                      height: 60,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      locationModel.name!,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: ConstantsColors.navigationColor2),
                    ),
                  ],
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
                      child: Consumer<ReviewsController>(
                        builder: (context, controller, _) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                              Consumer<ReviewsController>(
                                builder: (context, controller, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          for (int i = 0; i < 4; i++)
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.setBoolRating(
                                                        i,
                                                        !controller
                                                            .boolRatings[i]
                                                            .rating);
                                                  },
                                                  child: Icon(
                                                    controller.boolRatings[i]
                                                                .rating ==
                                                            true
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: ConstantsColors
                                                        .bottomSheetBackGround,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  controller
                                                      .boolRatings[i].uiString,
                                                  style: TextStyle(
                                                      color: ConstantsColors
                                                          .bottomSheetBackGround,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          for (int i = 4;
                                              i < controller.boolRatings.length;
                                              i++)
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.setBoolRating(
                                                        i,
                                                        !controller
                                                            .boolRatings[i]
                                                            .rating);
                                                  },
                                                  child: Icon(
                                                    controller.boolRatings[i]
                                                                .rating ==
                                                            true
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: ConstantsColors
                                                        .bottomSheetBackGround,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  controller
                                                      .boolRatings[i].uiString,
                                                  style: TextStyle(
                                                      color: ConstantsColors
                                                          .bottomSheetBackGround,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Consumer<ReviewsController>(
                    builder: (context, controller, child) {
                      return Column(
                        children: [
                          for (int i = 0; i < controller.ratings.length; i++)
                            AddRatingIndex(
                              title: controller.ratings[i].uiString,
                              color: ConstantsColors.navigationColor,
                              widget: InkWell(
                                onTap: () {
                                  controller.setRating(i, 0);
                                },
                                child: Icon(
                                  Icons.restore,
                                  color: ConstantsColors.navigationColor,
                                  size: 20,
                                ),
                              ),
                              index: controller.ratings[i].rating,
                              onChanged: (value) {
                                controller.setRating(i, value);
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Consumer<ReviewsController>(
                  builder: (context, controller, _) {
                    return ValueListenableBuilder<Map<String, dynamic>>(
                        valueListenable:
                            ReviewsController.reviewsValuesNotifier,
                        builder: (context, entity, _) {
                          return CustomButton(
                            text: "Add Review",
                            width: size.width * .5,
                            onPressed: () async {
                              final res = await controller.addReview(
                                context,
                                map: {
                                  // "location_id": locationModel.id,
                                  // "instant_coffee":
                                  //     entity["instant_coffee"] ?? false,
                                  // "beans_coffee":
                                  //     entity["ground_coffee"] ?? false,
                                  // "alternate_options":
                                  //     entity["alternate_options"] ?? false,
                                  // "sit_down": entity["sit_down"] ?? false,
                                  // "is_free": false,
                                  // "key_required":
                                  //     entity["key_required"] ?? false,
                                  // "wheelchair_friendly":
                                  //     entity["wheelchair_friendly"] ?? false,

                                  for (final boolMap in controller.boolRatings)
                                    boolMap.key: boolMap.rating,
                                  for (final map in controller.ratings)
                                    map.key: map.rating
                                },
                              );
                              if (res == true) {
                                Navigator.pop(context);
                                showSnackBar(context,
                                    text: "review added successfully",
                                    color: Colors.green);
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
      );
    },
  );
}
