import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/invoice_screen/invoice_dl.dart';
import 'package:lion_sales/screens/home/product_details/product_details_screen.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import 'invoice_repo.dart';

class InvoiceBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;

  InvoiceBloc(this.context, this.state);

  final InvoiceRepo _repo = InvoiceRepo();

  final BehaviorSubject<ApiResponse<InvoiceModel>> _invoiceSubject =
      BehaviorSubject<ApiResponse<InvoiceModel>>();
  BehaviorSubject<ApiResponse<InvoiceModel>> get invoiceSubject =>
      _invoiceSubject;

  getInvoiceDetails({required int orderId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      invoiceSubject.add(ApiResponse.loading());
      try {
        _repo.getInvoice(orderId).then((response) {
          if (response.data['status_code'] == 200) {
            invoiceSubject.add(
                ApiResponse.completed(InvoiceModel.fromJson(response.data)));
          } else {
            invoiceSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          invoiceSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");

        invoiceSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      invoiceSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
        msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
        backgroundColor: ConstantColors.appBlackColor,
        textColor: ConstantColors.appWhiteColor,
      );
    }
  }

  @override
  void dispose() {
    invoiceSubject.close();
  }

  void gotoProductScreen({required int id}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) =>
            ProductDetailScreen(args: {ConstantStrings.PRODUCT_ID: id})));
  }
}
