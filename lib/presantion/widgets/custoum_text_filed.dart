import 'package:bath_room_app/core/colors/colours.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // final String hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscure;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? suffixOnTap;
  final bool? readOnly;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.obscure = false,
    this.onChanged,
    required this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.suffixOnTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.07;

    return SizedBox(
      width: screenWidth * .9,
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscure,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          filled: true,
          fillColor: ConstantsColors.navigationColor2,
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(.6), fontSize: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: suffixOnTap,
                child: Icon(suffixIcon, size: iconSize, color: Colors.white)),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(prefixIcon, size: iconSize, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: ConstantsColors.navigationColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: ConstantsColors.navigationColor, width: 2),
          ),
          focusColor: ConstantsColors.navigationColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: ConstantsColors.navigationColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: ConstantsColors.navigationColor, width: 1),
          ),
        ),
      ),
    );
  }
}
