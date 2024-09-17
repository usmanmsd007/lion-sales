import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/total_products/total_products_dl.dart';
import 'package:lion_sales/screens/home/total_products/total_products_repo.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class TotalProductBloc extends Bloc {
  // Variables
  BuildContext context;
  State state;
  final TotalProductRepo _repo = TotalProductRepo();
  TotalProductBloc(this.context, this.state);

  final BehaviorSubject<ApiResponse<TotalProductsModel>>
      _totalProductListSubject =
      BehaviorSubject<ApiResponse<TotalProductsModel>>();
  BehaviorSubject<ApiResponse<TotalProductsModel>>
      get totalProductListSubject => _totalProductListSubject;

  onGetProducts() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      totalProductListSubject.add(ApiResponse.loading());
      try {
        _repo.getAllProducts().then((response) {
          if (response.data['status_code'] == 200) {
            totalProductListSubject.add(ApiResponse.completed(
                TotalProductsModel.fromJson(response.data)));
          } else {
            totalProductListSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          totalProductListSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");

        totalProductListSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      totalProductListSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  @override
  void dispose() {
    totalProductListSubject.done;
  }
}
