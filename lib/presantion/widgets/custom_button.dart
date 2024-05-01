import 'package:bath_room_app/core/colors/colours.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final String text;
  final Color? color;
  final Color? textColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.onPressed,
    this.width = 150,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: 50,
          width: width,
          decoration: BoxDecoration(
            color: color ?? ConstantsColors.fillColor3,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? ConstantsColors.navigationColor2,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
          )),
    );
  }
}
