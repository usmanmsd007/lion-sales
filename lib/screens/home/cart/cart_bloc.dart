import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/my_locator.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:lion_sales/screens/home/cart/cart_dl.dart';
import 'package:lion_sales/utils/flutter_secure_storage_utils.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import 'cart_repo.dart';

class CartBloc extends Bloc {
  // Variables
  BuildContext context;
  State<StatefulWidget> state;
  //  Constructor
  final CartRepo _repo = CartRepo();
  TextEditingController searchUserTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BehaviorSubject<ApiResponse<CartListModel>> _cartSubject =
      BehaviorSubject<ApiResponse<CartListModel>>();
  BehaviorSubject<ApiResponse<CartListModel>> get cartSubject => _cartSubject;

  final BehaviorSubject<List<CartUser>> _userSeachResult =
      BehaviorSubject<List<CartUser>>();
  BehaviorSubject<List<CartUser>> get userSearchResult => _userSeachResult;

  final BehaviorSubject<ApiResponse> _addOrRemoveSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get addOrRemoveSubject => _addOrRemoveSubject;

  final BehaviorSubject<ApiResponse> _clearCartSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get clearCartSubject => _clearCartSubject;

  final BehaviorSubject<CartUser?> _selectedDropDownValue =
      BehaviorSubject<CartUser>();
  BehaviorSubject<CartUser?> get selectedDropDownValue =>
      _selectedDropDownValue;

  final BehaviorSubject<bool> _isSearching =
      BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> get isSearching => _isSearching;

  final BehaviorSubject<ApiResponse> _sendOrderSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get sendOrderSubject => _sendOrderSubject;
  CartBloc(this.context, this.state);

  selectFromSearch(CartUser user) {
    selectedDropDownValue.add(user);
    storeCartUser(user);
    Navigator.pop(context);
  }

  onSearchFieldChange(String v) {
    isSearching.add(true);
    searchProducts(v);
  }

  clearText() {
    searchUserTextController.clear();
    userSearchResult.add(List.of(cartSubject.value.data!.usersList));
    isSearching.add(false);
  }

  searchProducts(String title) async {
    log(title, name: "title");
    if (title.isEmpty) {
      userSearchResult.add(List.of(cartSubject.value.data!.usersList));

      isSearching.add(false);
    } else {
      List<CartUser> searched = [];
      for (var element in cartSubject.value.data!.usersList) {
        if (element.name.toLowerCase().contains(title.toLowerCase())) {
          searched.add(element);
          log(element.name, name: "name of product");
        }
      }

      userSearchResult.value.clear();

      userSearchResult.add(searched);
    }
  }

  onGetCartList() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      cartSubject.add(ApiResponse.loading());
      try {
        _repo.getCartList().then((response) {
          if (response.data['status_code'] == 200) {
            cartSubject.add(
                ApiResponse.completed(CartListModel.fromJson(response.data)));
          } else {
            cartSubject.add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          cartSubject.add(ApiResponse.error(error.toString()));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");

        cartSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      cartSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  Future<void> refreshGetCartList() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      addOrRemoveSubject.add(ApiResponse.loading());
      try {
        await _repo.getCartList().then((response) {
          if (response.data['status_code'] == 200) {
            addOrRemoveSubject.add(ApiResponse.completed());

            cartSubject.add(
                ApiResponse.completed(CartListModel.fromJson(response.data)));
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
        log("${error.toString()}\n$stackTrace", name: "CART_LOG");

        addOrRemoveSubject.add(ApiResponse.error(error.toString()));
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

  void addToCart({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        addOrRemoveSubject.add(ApiResponse.loading());
        _repo.addToCart(productId).then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
            refreshGetCartList();
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

        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");
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

  void decrementProductFromCart({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        addOrRemoveSubject.add(ApiResponse.loading());
        _repo.decrementProductFromCart(productId).then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
            refreshGetCartList();
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

        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");
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

  void removeProductFromCart({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        addOrRemoveSubject.add(ApiResponse.loading());
        _repo.removeProductFromCart(productId).then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
            refreshGetCartList();
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

        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");
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

  void sendOrder() async {
    if (formKey.currentState!.validate()) {
      if (!selectedDropDownValue.hasValue) {
        Fluttertoast.showToast(msg: "Please select a user");
      } else {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          try {
            sendOrderSubject.add(ApiResponse.loading());

            _repo
                .sendOrder(
                    cartSubject.value.data!.cartList.first.orderId,
                    cartSubject.value.data!.cartList.first.products
                        .map((e) => {
                              ConstantStrings.PRODUCT_ID: e.productId,
                              ConstantStrings.QUANTITY.toLowerCase():
                                  e.quantity,
                            })
                        .toList(),
                    selectedDropDownValue.hasValue
                        ? selectedDropDownValue.value!.id
                        : null,
                    descriptionTextController.text)
                .then((response) async {
              await AppEncryptedStorage()
                  .deleteItem(key: ConstantStrings.CART_USER);
              if (response.data['status_code'] == 200) {
                var bottomNavBloc = locator.get<BottomNavBloc>();
                Fluttertoast.showToast(
                    msg: response.data[ConstantStrings.MESSAGE]);
                refreshGetCartList();
                sendOrderSubject.add(ApiResponse.completed());
                bottomNavBloc.addIndex(1);
              } else {
                sendOrderSubject
                    .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
                Fluttertoast.showToast(
                  msg: response.data[ApiParam.MESSAGE],
                  backgroundColor: ConstantColors.appBlackColor,
                  textColor: ConstantColors.appWhiteColor,
                );
              }
            }).onError((DioException error, stackTrace) {
              sendOrderSubject.add(ApiResponse.error(error.message));
              Fluttertoast.showToast(
                msg: error.message.toString(),
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
              );
            });
          } catch (error, stackTrace) {
            sendOrderSubject.add(ApiResponse.error(error.toString()));

            log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");
          }
        } else {
          sendOrderSubject.add(ApiResponse.error(
              ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
          Fluttertoast.showToast(
            msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
            backgroundColor: ConstantColors.appBlackColor,
            textColor: ConstantColors.appWhiteColor,
          );
        }
      }
    }
  }

  void populateSearchUsers() {
    userSearchResult.add(List.of(cartSubject.value.data!.usersList));
  }

  storeCartUser(CartUser cartUser) async {
    await AppEncryptedStorage().addItem(
        key: ConstantStrings.CART_USER, value: cartUserToString(cartUser));
  }

  checkIfUserExist() async {
    var a =
        await AppEncryptedStorage().readItem(key: ConstantStrings.CART_USER);
    if (a != null) {
      setSelectedUser(getUserFromJson(a));
    }
  }

  CartUser getUserFromJson(String userString) {
    return CartUser.fromJson(jsonDecode(userString));
  }

  String cartUserToString(CartUser u) {
    return jsonEncode(u.toJson());
  }

  setSelectedUser(CartUser user) {
    selectedDropDownValue.add(user);
  }

  void closeKeyBoard(bool isKeyboardOpen) {
    if (isKeyboardOpen) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  Future<void> clearCart() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _clearCartSubject.add(ApiResponse.loading());
      try {
        _repo.clearCart().then((response) {
          if (response.data['status_code'] == 200) {
            log(response.toString(), name: "CLEAR_CART_RESPONSE");
            final ClearCartModel model =
                ClearCartModel.fromJson(jsonDecode(response.toString()));
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: model.message);
            refreshGetCartList().then((value) => _clearCartSubject.add(
                ApiResponse.completed(ClearCartModel.fromJson(response.data))));
          } else {
            _clearCartSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          _clearCartSubject.add(ApiResponse.error(error.toString()));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "CLEAR_CART");

        _clearCartSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      _clearCartSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  @override
  void dispose() async {
    await cartSubject.done;
    await sendOrderSubject.done;
    await _cartSubject.done;
    // print('disposed');
  }
}
