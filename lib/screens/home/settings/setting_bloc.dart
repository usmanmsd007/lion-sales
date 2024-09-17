import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/screens/home/settings/setting_repo.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/flutter_secure_storage_utils.dart';
import '../../auth/login/login_dl.dart';

class SettingBloc extends Bloc {
  BuildContext context;
  //  Constructor
  SettingBloc(
    this.context,
  );
  final SettingRepo _repo = SettingRepo();

  final BehaviorSubject<ApiResponse> _logoutSubject =
      BehaviorSubject<ApiResponse>();

  BehaviorSubject<ApiResponse> get logoutSubject => _logoutSubject;

  final BehaviorSubject<String> _name = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> get name => _name;

  setInitialData() {
    AppEncryptedStorage().readItem(key: ConstantStrings.USER).then((value) {
      name.add(
          "${LoginModel.fromJson(jsonDecode(value!)).data.user.fullname} ${LoginModel.fromJson(jsonDecode(value)).data.user.lastName}");
    });
  }

  void logOut() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        logoutSubject.add(ApiResponse.loading());

        _repo.logout().then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(msg: response.data[ConstantStrings.MESSAGE]);
            logoutSubject.add(ApiResponse.completed());
            AppEncryptedStorage()
                .deleteItem(key: ConstantStrings.TOKEN_KEY)
                .then((value) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(
                      AppRoutes.LOGIN_SCREEN, (route) => false);
            });
          } else {
            logoutSubject.add(ApiResponse.error());
            Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          logoutSubject.add(ApiResponse.error());
          Fluttertoast.showToast(
              msg: error.message.toString(),
              gravity: ToastGravity.TOP,
              backgroundColor: ConstantColors.appWhiteColor);
        });
      } catch (error, stackTrace) {
        logoutSubject.add(ApiResponse.error());

        log("${error.toString()}\n$stackTrace", name: "LOGOUT_LOG");
      }
    } else {
      logoutSubject.add(ApiResponse.error());
      Fluttertoast.showToast(
        msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
        gravity: ToastGravity.TOP,
      );
    }
  }

  @override
  void dispose() async {}
}
