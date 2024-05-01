// Show Toast Message
import 'package:bath_room_app/core/colors/colours.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage({
  required String text,
  Color? color,
}) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: color ?? ConstantsColors.navigationColor,
    fontSize: 18,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
  );
}