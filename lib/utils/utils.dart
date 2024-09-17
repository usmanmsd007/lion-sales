import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant_colors.dart';
import 'constant_variables.dart';

TextStyle bodyText(
    {FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return poppinsTextStyle(
      fontWeight: fontWeight, fontSize: fontSize, textColor: textColor);
}

TextStyle poppinsTextStyle(
    {FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: textColor ?? ConstantColors.colorTextCommon,
        fontSize: fontSize ??
            deviceAverageSize * (fontSize ?? ConstantVariables.textSizeRegular),
        decoration: TextDecoration.none,
      ),
      fontWeight: fontWeight ?? FontWeight.normal);
}
