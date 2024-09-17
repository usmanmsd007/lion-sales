import 'package:flutter/material.dart'; 

import 'app_loading_widget.dart';

class AppLoadingWidgetTwo extends StatelessWidget {
  const AppLoadingWidgetTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoadingWidget());
  }
}
