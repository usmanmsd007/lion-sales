import 'package:flutter/material.dart';

class ConstantVariables {
  static const double textSizeRegular = 0.027;

  //Common Text Size
  static const double textSizeMediumBig = 0.028;
  static const double textSizeSmall = 0.026;
}

InputDecoration myDecoration = InputDecoration(
    filled: true,
    hintStyle: const TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 2.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ));

double deviceWidth = 0;
double deviceHeight = 0;
double deviceAverageSize = 0;
