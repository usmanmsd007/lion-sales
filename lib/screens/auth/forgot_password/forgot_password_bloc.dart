import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/routes/app_routes.dart';
import 'package:lion_sales/screens/auth/forgot_password/forgot_password_repo.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class ForgotPasswordBloc extends Bloc {
  // Variables
  BuildContext context;
  State<StatefulWidget> state;

  //for network call
  String _email = '';
  String _otp = '';

  final ForgetPasswordRepo _repo = ForgetPasswordRepo();
  final GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final BehaviorSubject<ApiResponse> _forgetPasswordSubject =
      BehaviorSubject<ApiResponse>();
  final BehaviorSubject<ApiResponse> _verifyOtpSubject =
      BehaviorSubject<ApiResponse>();
  final BehaviorSubject<ApiResponse> _changePasswordSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get forgetPasswordSubject =>
      _forgetPasswordSubject;
  BehaviorSubject<ApiResponse> get verifyOtpSubject => _verifyOtpSubject;
  BehaviorSubject<ApiResponse> get changePasswordSubject =>
      _changePasswordSubject;

  final BehaviorSubject<int> _screenNumber = BehaviorSubject<int>.seeded(1);

  final BehaviorSubject<bool> _showPassword =
      BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<int?> get isMailSubmitted => _screenNumber;

  //  Constructor
  ForgotPasswordBloc(this.context, this.state);

  BehaviorSubject<bool> get showPassword => _showPassword;

  void changeVisibility() => _showPassword.add(!_showPassword.value);

  void changeState(int no) => isMailSubmitted.add(no);
  void forgetPassword({required String email}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      forgetPasswordSubject.add(ApiResponse.loading());
      try {
        _repo.forgetPassword(email: email.trim()).then((response) {
          if (response.data['status_code'] == 200) {
            forgetPasswordSubject.add(ApiResponse.completed());
            _email = email;
            changeState(2);
          } else {
            forgetPasswordSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          forgetPasswordSubject.add(ApiResponse.error(error.toString()));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "LOGIN_LOG");

        forgetPasswordSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      forgetPasswordSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  void onForgetPassword() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (emailFormKey.currentState!.validate()) {
      forgetPassword(email: emailController.text.trim());
    }
  }

  void onChangePassword() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (newPasswordFormKey.currentState!.validate()) {
      changePassword(
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text);

      changeState(4);
    }
  }

  void changePassword(
      {required String password, required String confirmPassword}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      changePasswordSubject.add(ApiResponse.loading());
      try {
        _repo
            .changePassword(password, confirmPassword, _email, _otp)
            .then((response) {
          if (response.data['status_code'] == 200) {
            changePasswordSubject.add(ApiResponse.completed());
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
            changeState(4);
          } else {
            changePasswordSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          changePasswordSubject.add(ApiResponse.error(error.toString()));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CHANGE_PASSWORD_LOG");

        changePasswordSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      changePasswordSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.LOGIN_SCREEN, (route) => false);
  }

  verifyOtp() {
    if (otpFormKey.currentState!.validate()) {
      // verifyOtpSubject.add(ApiResponse.completed());
      // changeState(3);
      onVerifyOtp(otp: otpController.text.trim());
    }
  }

  void onVerifyOtp({required String otp}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      verifyOtpSubject.add(ApiResponse.loading());
      try {
        _repo
            .verifyOtp(
          otp,
          _email,
        )
            .then((response) {
          if (response.data['status_code'] == 200 ||
              response.data['status_code'] == 201) {
            _otp = otp;
            verifyOtpSubject.add(ApiResponse.completed());
            changeState(3);
          } else {
            verifyOtpSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            log(response.data[ApiParam.MESSAGE]);
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          verifyOtpSubject.add(ApiResponse.error(error.toString()));
          Fluttertoast.showToast(
            msg: error.message.toString(),
            backgroundColor: ConstantColors.appBlackColor,
            textColor: ConstantColors.appWhiteColor,
          );
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CHANGE_PASSWORD_LOG");

        verifyOtpSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      verifyOtpSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
  }
}
