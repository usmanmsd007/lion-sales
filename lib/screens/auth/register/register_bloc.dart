import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/auth/register/register_repo.dart';

import '../../../blocs/bloc.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class RegisterBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;
  final RegisterRepo _repo = RegisterRepo();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BehaviorSubject<bool> _showPassword =
      BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showPassword => _showPassword;
  void changeVisibility() => _showPassword.add(!_showPassword.value);

  final BehaviorSubject<bool> _showLoading =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _showIcon = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get showIcon => _showIcon;

  final BehaviorSubject<ApiResponse> _registerSubject =
      BehaviorSubject<ApiResponse>();

  BehaviorSubject<bool> get showLoading => _showLoading;

  BehaviorSubject<ApiResponse> get registerSubject => _registerSubject;

  void updateLoading() => _showLoading.add(!_showLoading.value);

  RegisterBloc(this.context, this.state);

  changeIconVisibility(bool show) {
    showIcon.add(show);
  }

  void registerUser() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (formKey.currentState!.validate()) {
      changeIconVisibility(true);
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        registerSubject.add(ApiResponse.loading());

        try {
          _repo
              .register(
                  firstNameController.text.trim(),
                  lastNameController.text.trim(),
                  emailController.text.trim(),
                  passwordController.text.trim())
              .then((response) async {
            if (response.data[ApiParam.STATUS_CODE] == 201) {
              registerSubject.add(ApiResponse.completed());
              if (!state.mounted) return;
              Fluttertoast.showToast(
                  backgroundColor: ConstantColors.appBlackColor,
                  textColor: ConstantColors.appWhiteColor,
                  msg: response.data[ApiParam.MESSAGE]);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.LOGIN_SCREEN, (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
              );
            }
          }).onError((DioException error, stackTrace) {
            if (error.response!.statusCode == 422) {
              registerSubject.add(ApiResponse.error(
                  error.response!.data[ConstantStrings.MESSAGE]));
              Fluttertoast.showToast(
                  msg: error.response!.data[ConstantStrings.MESSAGE]);
            } else {
              registerSubject.add(ApiResponse.error(error.toString()));

              Fluttertoast.showToast(msg: error.message.toString());
            }
          });
        } catch (error, stackTrace) {
          log("${error.toString()}\n$stackTrace", name: "REGISTER_LOG");

          registerSubject.add(ApiResponse.error(error.toString()));
        }
      } else {
        registerSubject.add(
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

  @override
  void dispose() {}
}
