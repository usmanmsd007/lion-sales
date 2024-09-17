import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/screens/auth/login/login_repo.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/flutter_secure_storage_utils.dart';

import '../../../routes/app_routes.dart';

class LoginBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;

  final LoginRepo _repo = LoginRepo();

  LoginBloc(this.context, this.state) {
    getUserCredentials();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BehaviorSubject<ApiResponse> _loginSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get loginSubject => _loginSubject;

  final BehaviorSubject<bool> _showPassword =
      BehaviorSubject<bool>.seeded(true);

  BehaviorSubject<bool> get showPassword => _showPassword;

  void changeVisibility() => _showPassword.add(!_showPassword.value);

  void changeIconVisibility(bool a) => showIcon.add(a);

  final BehaviorSubject<bool> _showIcon = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showIcon => _showIcon;

  void navigateToRegister() {
    Navigator.pushNamed(context, AppRoutes.REGISTER_SCREEN);
  }

  void navigateToForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.FORGOT_PASSWORD_SCREEN);
  }

  void onLogin() { 
    loginApiCall(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  void loginApiCall({required String email, required String password}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (formKey.currentState!.validate()) {
      changeIconVisibility(true);
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        loginSubject.add(ApiResponse.loading());
        try {
          _repo
              .login(email: email.trim(), password: password.trim())
              .then((response) {
            if (response.data['status_code'] == 200) {
              AppEncryptedStorage()
                  .addItem(key: ConstantStrings.USER_EMAIL, value: email.trim())
                  .then((value) => AppEncryptedStorage()
                      .addItem(
                          key: ConstantStrings.USER_PASSWORD,
                          value: password.trim())
                      .then((value) => AppEncryptedStorage()
                              .addItem(
                                  key: ConstantStrings.TOKEN_KEY,
                                  value: response.data[ApiParam.DATA]
                                      [ApiParam.TOKEN])
                              .then((value) {
                            AppEncryptedStorage()
                                .addItem(
                                    key: ConstantStrings.USER,
                                    value: jsonEncode(response.data))
                                .then(
                              (value) {
                                loginSubject.add(ApiResponse.completed());

                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.BOTTOM_NAV_SCREEN, (h) => false);
                              },
                            );
                          })));
            } else {
              loginSubject
                  .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));

              Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
              );
            }
          }).onError((DioException error, stackTrace) {
            loginSubject.add(ApiResponse.error(error.toString()));
            Fluttertoast.showToast(
              msg: error.message.toString(),
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          });
        } catch (error, stackTrace) {
          log("${error.toString()}\n$stackTrace", name: "LOGIN_LOG");

          loginSubject.add(ApiResponse.error(error.toString()));
        }
      } else {
        loginSubject.add(
            ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

        Fluttertoast.showToast(
            backgroundColor: ConstantColors.appBlackColor,
            textColor: ConstantColors.appWhiteColor,
            msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
      }
    } else {
      changeIconVisibility(false);
    }
  }

  Future<void> getUserCredentials() async {
    await AppEncryptedStorage()
        .readItem(key: ConstantStrings.USER_EMAIL)
        .then((value) => value.toString() != "null"
            ? emailController.text = value.toString()
            : emailController.text = "")
        .then((value) => AppEncryptedStorage()
            .readItem(key: ConstantStrings.USER_PASSWORD)
            .then((value) => value.toString() != "null"
                ? passwordController.text = value.toString()
                : passwordController.text = ""));
  }

  @override
  void dispose() {
    loginSubject.close();
  }
}
