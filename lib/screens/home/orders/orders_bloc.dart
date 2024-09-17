import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/orders/orders_dl.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import 'orders_repo.dart';

class OrdersBloc extends Bloc {
  BuildContext context;
  State<StatefulWidget> state;

  OrdersBloc(this.context, this.state);

  final OrderRepo _repo = OrderRepo();

  final BehaviorSubject<ApiResponse<OrderListModel>> _orderSubject =
      BehaviorSubject<ApiResponse<OrderListModel>>();
  BehaviorSubject<ApiResponse<OrderListModel>> get orderSubject =>
      _orderSubject;

  onGetCartList() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      orderSubject.add(ApiResponse.loading());
      try {
        _repo.getOrderList().then((response) {
          if (response.data['status_code'] == 200) {
            orderSubject.add(
                ApiResponse.completed(OrderListModel.fromJson(response.data)));
          } else {
            orderSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          orderSubject.add(ApiResponse.error(error.message));

          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");

        orderSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      orderSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  @override
  void dispose() {}
}

class OrderNewModel {
  String status;
  int statusCode;
  List<OrderListDatum> orderListData;

  OrderNewModel({
    required this.status,
    required this.statusCode,
    required this.orderListData,
  });

  factory OrderNewModel.fromJson(Map<String, dynamic> json) => OrderNewModel(
        status: json["status"],
        statusCode: json["status_code"],
        orderListData: List<OrderListDatum>.from(
            json["order_list_data"].map((x) => OrderListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "order_list_data":
            List<dynamic>.from(orderListData.map((x) => x.toJson())),
      };
}

class OrderListDatum {
  int orderId;
  double totalAmount;
  String userName;

  OrderListDatum({
    required this.orderId,
    required this.totalAmount,
    required this.userName,
  });

  factory OrderListDatum.fromJson(Map<String, dynamic> json) => OrderListDatum(
        orderId: json["order_id"],
        totalAmount: json["total_amount"]?.toDouble(),
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_amount": totalAmount,
        "user_name": userName,
      };
}
