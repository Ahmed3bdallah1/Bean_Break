import 'package:bath_room_app/core/colors/colours.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, {required String text, Color? color,Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration?? const Duration(seconds: 3),
      backgroundColor: color ?? ConstantsColors.navigationColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
