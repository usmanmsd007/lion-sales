import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/screens/home/cart/cart_dl.dart';
import 'package:lion_sales/screens/home/product_details/product_details_dl.dart';
import 'package:lion_sales/screens/home/product_details/product_details_repo.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class ProductDetailsBloc extends Bloc {
  // Variables
  BuildContext context;
  State<StatefulWidget> state;

  final ProductDetailRepo _repo = ProductDetailRepo();

  final BehaviorSubject<ApiResponse<ProductDetailModel>> _productDetailSubject =
      BehaviorSubject<ApiResponse<ProductDetailModel>>();
  BehaviorSubject<ApiResponse<ProductDetailModel>> get productDetailSubject =>
      _productDetailSubject;

  final BehaviorSubject<ApiResponse> _addOrRemoveSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get addOrRemoveSubject => _addOrRemoveSubject;

  final BehaviorSubject<bool> _isAlreadyAdded = BehaviorSubject<bool>();
  BehaviorSubject<bool> get isAlreadyAdded => _isAlreadyAdded;

  final BehaviorSubject<int> _counter = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<int> get counter => _counter;

  void addToCart({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        addOrRemoveSubject.add(ApiResponse.loading());
        _repo.addToCart(productId).then((response) async {
          if (response.data['status_code'] == 200) {
            await checkIfProductAddOrNot(productId).then((value) {
              addOrRemoveSubject.add(ApiResponse.completed());
            });
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
          } else {
            addOrRemoveSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          addOrRemoveSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        addOrRemoveSubject.add(ApiResponse.error(error.toString()));

        log("${error.toString()}\n$stackTrace", name: "ADD_TO_CART_LOG");
      }
    } else {
      addOrRemoveSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  onGetProductsDetails({required int id}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      productDetailSubject.add(ApiResponse.loading());
      try {
        _repo.getProductDetails(id).then((response) {
          if (response.data['status_code'] == 200) {
            productDetailSubject.add(ApiResponse.completed(
                ProductDetailModel.fromJson(response.data)));
          } else {
            productDetailSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          productDetailSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "PRODUCT_DETAILS_LOG");

        productDetailSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      productDetailSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  //  Constructor
  ProductDetailsBloc(this.context, this.state);

  @override
  void dispose() {
    productDetailSubject.close();
  }

  Future checkIfProductAddOrNot(int productId) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        return _repo.getCartList().then((response) {
          if (response.data['status_code'] == 200) {
            var model = CartListModel.fromJson(response.data);
            for (var element in model.cartList[0].products) {
              if (element.productId == productId) {
                isAlreadyAdded.add(true);
              }
            }
          } else {
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");
      }
    } else {
      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }
}
