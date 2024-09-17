import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lion_sales/utils/constant_colors.dart';

import '../utils/constant_variables.dart';
import '../utils/utils.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) validate;
  final bool isPassword;
  final bool suffix;
  final String hintText;
  final String labelText;
  final TextInputAction action;
  final TextInputType keyboardType;
  final Function()? onEyeTap;
  final bool textColor;
  final int maxLines;
  final int maxLength;
  
  final Function(String?) onFieldSubmitted;

  const MyTextField(
      {super.key,
      this.textColor = true,
      this.maxLength = 0,
      this.maxLines = 1,
      required this.validate,
      required this.onFieldSubmitted,
      required this.labelText,
      required this.controller,
      this.action = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.suffix = false,
      required this.hintText,
      this.onEyeTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:
          poppinsTextStyle(textColor: textColor ? Colors.white : Colors.black),
      cursorColor: ConstantColors.appPrimaryColor,
      inputFormatters: maxLength == 0
          ? null
          : [
              LengthLimitingTextInputFormatter(maxLength),
            ],
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        suffixIcon: suffix
            ? isPassword
                ? GestureDetector(
                    onTap: onEyeTap,
                    child: const Icon(
                      Icons.visibility,
                      color: ConstantColors.appPrimaryColor,
                    ),
                  )
                : GestureDetector(
                    onTap: onEyeTap,
                    child: const Icon(
                      Icons.visibility_off,
                      color: ConstantColors.appPrimaryColor,
                    ),
                  )
            : const SizedBox(),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: ConstantColors.appPrimaryColor, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ConstantColors.appPrimaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),

        errorStyle: poppinsTextStyle(
          textColor: Colors.red,
        ).copyWith(height: 0),
        labelText: labelText,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04, vertical: deviceHeight * 0.010),
        labelStyle: poppinsTextStyle(textColor: ConstantColors.appPrimaryColor)
            .copyWith(height: deviceHeight * 0.0008),
        hintStyle: poppinsTextStyle(textColor: ConstantColors.colorGreyText),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      controller: controller,
      validator: (value) => validate(value),
      obscureText: isPassword,
      textAlign: TextAlign.left,
      textInputAction: action,
      keyboardType: keyboardType,
    );
  }
}

class MySearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) validate;
  final Function() clearText;
  final Function(String?) onFieldSubmitted;
  final String hintText;
  final bool isSearching;
  final TextInputType keyboardType;

  const MySearchField({
    super.key,
    required this.clearText,
    required this.validate,
    this.isSearching = false,
    required this.onFieldSubmitted,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: poppinsTextStyle(textColor: Colors.black),
      cursorColor: ConstantColors.appPrimaryColor,
      decoration: InputDecoration(
        suffixIcon: isSearching
            ? GestureDetector(
                onTap: clearText, child: const Icon(Icons.highlight_remove))
            : GestureDetector(
                onTap: () {
                  onFieldSubmitted(controller.text);
                },
                child: const Icon(
                  Icons.search_sharp,
                  color: Colors.black,
                )),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: ConstantColors.appPrimaryColor, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ConstantColors.appPrimaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),

        errorStyle: poppinsTextStyle(
          textColor: Colors.red,
        ).copyWith(height: 0),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04, vertical: deviceHeight * 0.010),

        labelStyle: poppinsTextStyle(textColor: ConstantColors.appPrimaryColor)
            .copyWith(height: deviceHeight * 0.0008),
        hintStyle: poppinsTextStyle(textColor: ConstantColors.colorGreyText),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => validate(value),
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.search,
      keyboardType: keyboardType,
    );
  }
}

class UserSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) validate;
  final Function() clearText;
  final Function(String?) onTextChange;
  final String hintText;
  final bool isSearching;

  const UserSearchField({
    super.key,
    required this.clearText,
    required this.validate,
    this.isSearching = false,
    required this.onTextChange,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: poppinsTextStyle(textColor: Colors.black),
      cursorColor: ConstantColors.appPrimaryColor,
      onChanged: onTextChange,
      decoration: InputDecoration(
        suffixIcon: isSearching
            ? GestureDetector(
                onTap: clearText, child: const Icon(Icons.highlight_remove))
            : GestureDetector(
                onTap: () {
                  // onTextChange(controller.text);
                },
                child: const Icon(
                  Icons.search_sharp,
                  color: Colors.black,
                )),

        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: ConstantColors.appPrimaryColor, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ConstantColors.appPrimaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),

        errorStyle: poppinsTextStyle(
          textColor: Colors.red,
        ).copyWith(height: 0),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04, vertical: deviceHeight * 0.010),

        labelStyle: poppinsTextStyle(textColor: ConstantColors.appPrimaryColor)
            .copyWith(height: deviceHeight * 0.0008),
        hintStyle: poppinsTextStyle(textColor: ConstantColors.colorGreyText),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      controller: controller,
      onFieldSubmitted: onTextChange,
      validator: (value) => validate(value),
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.search,
    );
  }
}
