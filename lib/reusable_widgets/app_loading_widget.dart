import 'package:flutter/material.dart';

import '../utils/constant_colors.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: ConstantColors.appPrimaryColor,
    );
  }
}
