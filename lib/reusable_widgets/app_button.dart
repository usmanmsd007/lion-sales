import 'package:flutter/material.dart';
import 'package:lion_sales/utils/extensions.dart';

import '../utils/constant_colors.dart';
import '../utils/utils.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
    this.radius = 30,
    required this.text,
  });

  final double height;
  final double width;
  final String text;
  final double radius;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: context.height / 14,
        width: width,
        decoration: BoxDecoration(
            color: ConstantColors.appPrimaryColor,
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: Text(
            text,
            style: poppinsTextStyle(
                textColor: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class AppButtonTwo extends StatelessWidget {
  const AppButtonTwo({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
    this.radius = 30,
    required this.text,
  });

  final double height;
  final double width;
  final String text;
  final double radius;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: ConstantColors.appPrimaryColor,
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: Text(
            text,
            style: poppinsTextStyle(
                textColor: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
