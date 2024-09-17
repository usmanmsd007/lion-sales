import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/splash/splash_repo.dart';
import 'package:lion_sales/utils/flutter_secure_storage_utils.dart';

import '../../blocs/bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/constant_strings.dart';

class SplashBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;
  Timer? _timer;
  final SplashRepo _repo = SplashRepo();

  SplashBloc(this.context, this.state) {
    splashAction();
  }

  void splashAction() {
    _timer = Timer(const Duration(seconds: 1), () async {
      await _repo.getApiVersion().then((response) {
        if (response is Response) {
          if (response.data['status_code'] == 200) {
            if (response.data['version'] == ConstantStrings.APP_VERSION) {
//             if (
//               true
//               // response.data['version'] ==
//               //   "${packageInfo.version }  +${packageInfo.buildNumber}"
//                 ) {
              AppEncryptedStorage()
                  .readItem(key: ConstantStrings.TOKEN_KEY)
                  .then((token) {
                if (token == null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.LOGIN_SCREEN, (route) => false);
                } else if (token.isEmpty) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.LOGIN_SCREEN, (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.BOTTOM_NAV_SCREEN, (route) => false);
                }
              });
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.UPDATE_APP_SCREEN, (route) => false);
            }
          } else {
            Fluttertoast.showToast(msg: "Failed to check for updates");
            AppEncryptedStorage()
                .readItem(key: ConstantStrings.TOKEN_KEY)
                .then((token) {
              if (token == null) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.LOGIN_SCREEN, (route) => false);
              } else if (token.isEmpty) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.LOGIN_SCREEN, (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.BOTTOM_NAV_SCREEN, (route) => false);
              }
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
  }
}
