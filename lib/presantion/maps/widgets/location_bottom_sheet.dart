import 'package:beak_break/core/controllers/location/location_controller.dart';
import 'package:beak_break/core/controllers/reviews/reviews_controller.dart';
import 'package:beak_break/core/routing/router.dart';
import 'package:beak_break/models/review_models/review_model.dart';
import 'package:beak_break/presantion/profile/widgets/review_widget.dart';
import 'package:beak_break/presantion/widgets/custom_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/colors/colours.dart';
import '../../../core/network/app_constants.dart';
import '../../../models/locations_model/location_model.dart';
import '../../home/widgets/ad_mob_container.dart';
import 'add_review_sheet.dart';
import 'location_info_container.dart';

void showLocationDetails(
  BuildContext context, {
  required LocationModel location,
  required bool isCafe,
  required bool isBathroom,
}) {
  showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: .8,
    backgroundColor: isCafe
        ? ConstantsColors.navigationColor2
        : ConstantsColors.bottomSheetBackGround,
    context: context,
    builder: (context) {
      final provider = Provider.of<LocationController>(context);
      Provider.of<ReviewsController>(context).getLocationReviews(
        context,
        locationId: location.id ?? "",
      );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image.asset(
                          isCafe && isBathroom == true
                              ? AppConstants.image3
                              : isCafe == true
                                  ? AppConstants.image2
                                  : AppConstants.image1,
                          height: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          location.name ?? "unknown",
                          style: TextStyle(
                              color: isCafe
                                  ? ConstantsColors.bottomSheetBackGround
                                  : ConstantsColors.navigationColor2,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: isCafe
                            ? ConstantsColors.fillColor3
                            : ConstantsColors.navigationColor2,
                      ))
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: isCafe
                      ? ConstantsColors.fillColor3
                      : ConstantsColors.navigationColor2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Flexible(
                          child: Text(
                        location.description ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCafe
                              ? ConstantsColors.navigationColor2
                              : ConstantsColors.bottomSheetBackGround,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 100, child: AdMobBanner()),
              LocationInfoContainer(locationModel: location),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        if (provider.checkFavorite(
                                locationId: location.id ?? "") ==
                            true) {
                          provider.removeFromFavorites(
                            context,
                            locationId: location.id ?? "",
                          );
                        } else {
                          provider.addToFavorites(
                            context,
                            locationId: location.id ?? "",
                          );
                        }
                      },
                      child: Icon(
                        provider.checkFavorite(locationId: location.id ?? "") ==
                                true
                            ? FontAwesomeIcons.solidBookmark
                            : FontAwesomeIcons.bookmark,
                        color: location.instantCoffee == false
                            ? ConstantsColors.navigationColor2
                            : ConstantsColors.fillColor3,
                      ),
                    ),
                    Icon(
                      Icons.share,
                      color: location.instantCoffee == false
                          ? ConstantsColors.navigationColor2
                          : ConstantsColors.fillColor3,
                    ),
                    InkWell(
                      onTap: () async {
                        if (AppConstants.token != '') {
                          print("a7a1");
                          final res =
                              await showAddReviewDetails(context, location);
                          print("a7a2");

                          Provider.of<ReviewsController>(context, listen: false)
                              .reset();
                        } else {
                          showCustomDialog(
                            context,
                            title: "Unauthorized",
                            body: "please login to access add review feature",
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
                      child: Image.asset(
                        AppConstants.image8,
                        width: 25,
                        color: location.instantCoffee == false
                            ? ConstantsColors.navigationColor2
                            : ConstantsColors.fillColor3,
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<List<ReviewModel>>(
                valueListenable: ReviewsController.locationReviewsNotifier,
                builder: (context, listener, _) {
                  if (listener.isEmpty) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: ListView.separated(
                      itemCount: listener.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 5);
                      },
                      itemBuilder: (context, index) {
                        return Review(
                          reviewModel: listener[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
