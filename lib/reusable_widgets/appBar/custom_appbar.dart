import 'package:flutter/material.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key,
      this.showBackButton = false,
      required this.title,
      required this.onTap});
  final String title;
  final void Function() onTap;
  final bool showBackButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height / 11,
      decoration: const BoxDecoration(color: ConstantColors.appBlackColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width / 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showBackButton
                ? GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.arrow_back,
                      color: ConstantColors.appPrimaryColor,
                    ),
                  )
                : Container(),
            Text(
              title,
              style: poppinsTextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  textColor: ConstantColors.appPrimaryColor),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
