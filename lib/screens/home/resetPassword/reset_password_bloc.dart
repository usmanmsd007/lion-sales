import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/resetPassword/reset_password_repo.dart';
import 'package:lion_sales/utils/constant_strings.dart';

import '../../../blocs/bloc.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/flutter_secure_storage_utils.dart';
import '../../auth/login/login_dl.dart';

class ResetPasswordBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;

  ResetPasswordBloc(this.context, this.state);
  String email = '';
  final ResetPasswordRepo _repo = ResetPasswordRepo();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BehaviorSubject<ApiResponse> _logoutSubject =
      BehaviorSubject<ApiResponse>();

  BehaviorSubject<ApiResponse> get logoutSubject => _logoutSubject;

  final BehaviorSubject<bool> _showPassword =
      BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showPassword => _showPassword;

  final BehaviorSubject<bool> _showPasswordTwo =
      BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showPasswordTwo => _showPasswordTwo;

  final BehaviorSubject<bool> _showPasswordThree =
      BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showPasswordThree => _showPasswordThree;

  final BehaviorSubject<String> _name = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> get name => _name;

  final BehaviorSubject<ApiResponse> _resetPasswordSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get resetPasswordSubject =>
      _resetPasswordSubject;

  onChangePassword(void Function() logoutDialog) async {
    if (formKey.currentState!.validate()) {
      changePassword(logoutDialog);
    }
  }

  changePassword(void Function() logoutDialog) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      resetPasswordSubject.add(ApiResponse.loading());
      try {
        _repo
            .resetPassword(email, oldPasswordController.text,
                passwordController.text, confirmPasswordController.text)
            .then((response) {
          if (response.data['status_code'] == 200) {
            resetPasswordSubject.add(ApiResponse.completed());
            logoutDialog();
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                textColor: ConstantColors.appWhiteColor,
                backgroundColor: ConstantColors.appBlackColor);
          } else {
            resetPasswordSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appBlackColor);
          }
        }).onError((DioException error, stackTrace) {
          resetPasswordSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "RESET_PASSWORDLOG");

        resetPasswordSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      resetPasswordSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  hidePassword() {
    showPassword.add(!showPassword.value);
  }

  hidePasswordThree() {
    showPasswordThree.add(!showPasswordThree.value);
  }

  hidePasswordTwo() {
    showPasswordTwo.add(!showPasswordTwo.value);
  }

  setInitialData() {
    AppEncryptedStorage().readItem(key: ConstantStrings.USER).then((value) =>
        email = LoginModel.fromJson(jsonDecode(value!)).data.user.email);
  }

  validateConfirmPassword(String? v) {
    if (v!.isEmpty) {
      return "Please fill this field";
    }
    if (v != passwordController.text) {
      return "Password do not match";
    }
    return null;
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

  validateOldPassword(String? v) {
    if (v!.isEmpty) {
      return "Please fill this field";
    }
    if (v.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  validatePassword(String? v) {
    if (v!.isEmpty) {
      return "Please fill this field";
    }
    if (v.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (v == oldPasswordController.text) {
      return "Please choose a different password";
    }
    return null;
  }

  @override
  void dispose() {}
}
