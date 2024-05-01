import 'package:bath_room_app/core/controllers/reviews/reviews_controller.dart';
import 'package:bath_room_app/core/network/app_constants.dart';
import 'package:bath_room_app/models/review_models/review_model.dart';
import 'package:bath_room_app/presantion/widgets/rating_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/colors/colours.dart';

class Review extends StatelessWidget {
  final ReviewModel reviewModel;

  const Review({super.key, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String myId = AppConstants.userId;
    return Container(
      width: size.width * .5,
      decoration: BoxDecoration(
        color: ConstantsColors.bottomSheetBackGround,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  reviewModel.userName ?? "",
                  style: TextStyle(
                      color: ConstantsColors.navigationColor2,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                reviewModel.userId == myId
                    ? Consumer<ReviewsController>(
                        builder: (context, controller, _) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("delete"),
                                    content: const Text(
                                        "this review will be deleted"),
                                    actions: [
                                      CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('close')),
                                      CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          onPressed: () async {
                                            await controller.deleteReview(
                                              context,
                                              locationId: reviewModel.id ?? "",
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text("delete")),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: ConstantsColors.navigationColor,
                              size: size.width * .058,
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                reviewModel.instantCoffee == true
                    ? Icon(
                        Icons.check_box_outlined,
                        color: ConstantsColors.navigationColor2,
                        size: size.width * .058,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: ConstantsColors.navigationColor2,
                        size: size.width * .058,
                      ),
                Text(
                  "Instant/Machine",
                  style: TextStyle(color: ConstantsColors.navigationColor2),
                ),
              ],
            ),
            Row(
              children: [
                reviewModel.beansCoffee == true
                    ? Icon(
                        Icons.check_box_outlined,
                        color: ConstantsColors.navigationColor2,
                        size: size.width * .058,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: ConstantsColors.navigationColor2,
                        size: size.width * .058,
                      ),
                Text(
                  "Grounds/Beans",
                  style: TextStyle(color: ConstantsColors.navigationColor2),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: ConstantsColors.navigationColor,
                        size: size.width * .058,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          ...buildRatingImages(
                            rating: reviewModel.priceRating!.toDouble(),
                            ratingAssetPath: AppConstants.image4,
                            ratingRemainPath: AppConstants.image5,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_food_beverage,
                        color: ConstantsColors.navigationColor,
                        size: size.width * .058,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          ...buildRatingImages(
                            rating: reviewModel.tasteRating!.toDouble(),
                            ratingAssetPath: AppConstants.image4,
                            ratingRemainPath: AppConstants.image5,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.ads_click,
                        color: ConstantsColors.navigationColor,
                        size: size.width * .058,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          ...buildRatingImages(
                            rating: reviewModel.selectionRating!.toDouble(),
                            ratingAssetPath: AppConstants.image4,
                            ratingRemainPath: AppConstants.image5,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.clean_hands,
                        color: ConstantsColors.navigationColor,
                        size: size.width * .058,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          ...buildRatingImages(
                            rating: reviewModel.cleanlinessRating!.toDouble(),
                            ratingAssetPath: AppConstants.image4,
                            ratingRemainPath: AppConstants.image5,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: ConstantsColors.navigationColor,
                        size: size.width * .058,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "East London",
                        style: TextStyle(
                            color: ConstantsColors.navigationColor2,
                            fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              reviewModel.createdDate.toString().substring(0, 10),
              style: TextStyle(color: ConstantsColors.navigationColor2),
            )
          ],
        ),
      ),
    );
  }
}
