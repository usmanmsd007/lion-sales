import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/dashboard/dashboard_repo.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class DashboardBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;
  //constructor
  DashboardBloc(this.context, this.state);
  final DashboardRepo _repo = DashboardRepo();

  final BehaviorSubject<ApiResponse<int>> _totalOrderSubject =
      BehaviorSubject<ApiResponse<int>>();
  BehaviorSubject<ApiResponse<int>> get totalOrderSubject => _totalOrderSubject;

  final BehaviorSubject<ApiResponse<int>> _totalProductsSubject =
      BehaviorSubject<ApiResponse<int>>();
  BehaviorSubject<ApiResponse<int>> get totalProductSubject =>
      _totalProductsSubject;

  getTotalOrders() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      totalOrderSubject.add(ApiResponse.loading());

      try {
        _repo.getTotalOrder().then((response) {
          if (response.data['status_code'] == 200) {
            totalOrderSubject.add(
                ApiResponse.completed(response.data['total_orders_of_user']));
          } else {
            totalOrderSubject
                .add(ApiResponse.error(response.data[ConstantStrings.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          totalOrderSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        totalOrderSubject.add(ApiResponse.error(error.toString()));
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");
      }
    } else {
      totalOrderSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
        msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
        backgroundColor: ConstantColors.appBlackColor,
        textColor: ConstantColors.appWhiteColor,
      );
    }
  }

  getTotalProduct() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      totalProductSubject.add(ApiResponse.loading());

      try {
        _repo.getTotalProduct().then((response) {
          if (response.data['status_code'] == 200) {
            totalProductSubject.add(
                ApiResponse.completed(response.data['total_no_of_products']));
          } else {
            totalProductSubject
                .add(ApiResponse.error(response.data[ConstantStrings.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          totalProductSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        totalProductSubject.add(ApiResponse.error(error.toString()));
        log("${error.toString()}\n$stackTrace", name: "TOTAL_PRODUCT_LOG");
      }
    } else {
      totalProductSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
        msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
        backgroundColor: ConstantColors.appBlackColor,
        textColor: ConstantColors.appWhiteColor,
      );
    }
  }

  @override
  void dispose() async {
    totalOrderSubject.done;
    totalProductSubject.done;
  }
}
