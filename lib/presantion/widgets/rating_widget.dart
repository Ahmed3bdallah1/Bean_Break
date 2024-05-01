import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:bath_room_app/core/colors/colours.dart';
import 'package:bath_room_app/core/controllers/reviews/reviews_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

List<Widget> buildRatingImages({required double rating,
  required String ratingAssetPath,
  required String ratingRemainPath}) {
  List<Widget> widgets = [];
  int ratingStars = rating.floor();
  int totalStars = 5;
  int remain = totalStars - ratingStars;

  // Add full star images
  for (int i = 0; i < ratingStars; i++) {
    widgets.add(Image.asset(ratingAssetPath, height: 20));
  }

  for (int i = 0; i < remain; i++) {
    widgets.add(Image.asset(ratingRemainPath, height: 20));
  }
  return widgets;
}

class AddRatingIndex extends StatefulWidget {
  final double index;
  final String title;
  final Widget? widget;
  Color? color = ConstantsColors.navigationColor;
  final void Function(double rating) onChanged;

  AddRatingIndex({
    super.key,
    required this.index,
    required this.onChanged,
    required this.title,
    this.color,
    this.widget,
  });

  @override
  State<AddRatingIndex> createState() => _AddRatingIndexState();
}

class _AddRatingIndexState extends State<AddRatingIndex> {
  double currentIndex = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                color: widget.color, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Row(
            children: [
              widget.widget ?? const SizedBox(),
              const SizedBox(width: 5),
              Consumer<ReviewsController>(
                builder: (context, controller,_) {
                  return AnimatedRatingStars(
                    key: ValueKey(widget.index),
                    initialRating:widget.index,
                    minRating: 0.0,
                    maxRating: 5.0,
                    filledColor: ConstantsColors.navigationColor,
                    emptyColor: ConstantsColors.fillColor3,
                    filledIcon: FontAwesomeIcons.mugSaucer,
                    emptyIcon: FontAwesomeIcons.mugSaucer,
                    onChanged: widget.onChanged,
                    displayRatingValue: true,
                    interactiveTooltips: true,
                    customFilledIcon: FontAwesomeIcons.mugSaucer,
                    customEmptyIcon: FontAwesomeIcons.mugSaucer,
                    customHalfFilledIcon: FontAwesomeIcons.mugSaucer,
                    starSize: 18,
                    animationDuration: const Duration(milliseconds: 300),
                    animationCurve: Curves.bounceIn,
                    readOnly: false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
