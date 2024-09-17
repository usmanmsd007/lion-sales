import 'dart:collection';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/screens/home/product_details/product_details_screen.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/screens/home/products/product_repo.dart';

import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';

class ProductBloc extends Bloc {
  // Variables
  BuildContext context;
  State state;
  final ProductRepo _repo = ProductRepo();

  //  Constructor
  ProductBloc(this.context, this.state);

  int pageNo = 1;
  int totalPage = 1;

  final allProductGridController = ScrollController();
  final searchProductGridController = ScrollController();

  int searchPageNo = 1;
  int searchTotalPage = 1;

  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

  final TextEditingController dialogBoxController = TextEditingController();
  final GlobalKey<FormState> dialogBoxFormKey = GlobalKey<FormState>();

  onSearchFieldSubmitted(
      {String v = '', bool isFiltered = false, required bool isCategories}) {
    searchPageNo = 1;
    if (isFiltered) {
      FocusManager.instance.primaryFocus!.unfocus();
      if (v.isNotEmpty) {
        showClear.add(true);
      }
      isSearching.add(true);

      searchProductsWithPageNoOne(v);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      if (searchFormKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus!.unfocus();

        showClear.add(true);

        isSearching.add(true);
        searchProductsWithPageNoOne(v);
      }
    }
  }

  applyFiltersWithoutText() {
    FocusManager.instance.primaryFocus!.unfocus();

    showClear.add(false);

    isSearching.add(true);
    searchProductsWithPageNoOne("");
  }

//
  clearText() {
    showClear.add(false);
    searchController.clear();
    applyFiltersWithoutText();
  }

  addListenerToScrollController() {
    allProductGridController.addListener(() {
      if (allProductGridController.position.maxScrollExtent ==
          allProductGridController.position.pixels) {
        if (pageNo < totalPage) {
          loadMore.add(true);

          loadMoreProducts(pageNo++);
        }
      }
    });
    searchProductGridController.addListener(() {
      if (searchProductGridController.position.maxScrollExtent ==
          searchProductGridController.position.pixels) {
        if (searchPageNo < searchTotalPage) {
          loadMore.add(true);

          loadMoreSearchProducts(searchPageNo++, searchController.text);
        }
      }
    });
  }

  final BehaviorSubject<bool> _loadMore = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> get loadMore => _loadMore;
  final BehaviorSubject<bool> _isSearching =
      BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> get isSearching => _isSearching;

  final BehaviorSubject<bool> _showClear = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> get showClear => _showClear;

  final BehaviorSubject<ApiResponse<ProductModel>> _productListSubject =
      BehaviorSubject<ApiResponse<ProductModel>>();
  BehaviorSubject<ApiResponse<ProductModel>> get productListSubject =>
      _productListSubject;

  final BehaviorSubject<ApiResponse<ProductModel>> _searchListSubject =
      BehaviorSubject<ApiResponse<ProductModel>>();
  BehaviorSubject<ApiResponse<ProductModel>> get searchListSubject =>
      _searchListSubject;

  final BehaviorSubject<ApiResponse> _addOrRemoveSubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get addOrRemoveSubject => _addOrRemoveSubject;

  final BehaviorSubject<ApiResponse> _changeQuantitySubject =
      BehaviorSubject<ApiResponse>();
  BehaviorSubject<ApiResponse> get changeQuantitySubject =>
      _changeQuantitySubject;

  final BehaviorSubject<ApiResponse<Categories>> _categories =
      BehaviorSubject<ApiResponse<Categories>>();
  BehaviorSubject<ApiResponse<Categories>> get categories => _categories;

  onGetProducts() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      productListSubject.add(ApiResponse.loading());
      try {
        _repo.getProducts(pageNo).then((response) {
          if (response.data['status_code'] == 200) {
            productListSubject.add(
                ApiResponse.completed(ProductModel.fromJson(response.data)));
            totalPage = response.data["total_pages"];
          } else {
            productListSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          productListSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");

        productListSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      productListSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  refreshProducts(int productId, bool increment) async {
    if (isSearching.value) {
      ProductModel searchProductModel = searchListSubject.value.data!;
      for (var element in searchProductModel.allProducts) {
        if (element.id == productId) {
          increment ? element.quantity++ : element.quantity--;
        }
      }
      addOrRemoveSubject.add(ApiResponse.completed());
      searchListSubject.add(ApiResponse.completed(searchProductModel));

      ProductModel productModel = productListSubject.value.data!;
      for (var element in productModel.allProducts) {
        if (element.id == productId) {
          increment ? element.quantity++ : element.quantity--;
        }
      }
      addOrRemoveSubject.add(ApiResponse.completed());
      productListSubject.add(ApiResponse.completed(productModel));
    } else {
      ProductModel productModel = productListSubject.value.data!;
      for (var element in productModel.allProducts) {
        if (element.id == productId) {
          increment ? element.quantity++ : element.quantity--;
        }
      }
      addOrRemoveSubject.add(ApiResponse.completed());
      productListSubject.add(ApiResponse.completed(productModel));
    }
  }

  refreshProductsForQuantity(int productId, int quantity) async {
    if (isSearching.value) {
      ProductModel searchProductModel = searchListSubject.value.data!;
      for (var element in searchProductModel.allProducts) {
        if (element.id == productId) {
          element.quantity = quantity;
        }
      }
      addOrRemoveSubject.add(ApiResponse.completed());
      changeQuantitySubject.add(ApiResponse.completed());
      searchListSubject.add(ApiResponse.completed(searchProductModel));

      ProductModel productModel = productListSubject.value.data!;
      for (var element in productModel.allProducts) {
        if (element.id == productId) {
          element.quantity = quantity;
        }
      }
      changeQuantitySubject.add(ApiResponse.completed());

      addOrRemoveSubject.add(ApiResponse.completed());
      productListSubject.add(ApiResponse.completed(productModel));
    } else {
      ProductModel productModel = productListSubject.value.data!;
      for (var element in productModel.allProducts) {
        if (element.id == productId) {
          element.quantity = quantity;
        }
      }
      changeQuantitySubject.add(ApiResponse.completed());

      addOrRemoveSubject.add(ApiResponse.completed());
      productListSubject.add(ApiResponse.completed(productModel));
    }
  }

  void gotoProductDetailsScreen({required int id}) {
    log('$id');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) =>
                ProductDetailScreen(args: {ConstantStrings.PRODUCT_ID: id})));
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
            refreshProducts(productId, true);
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

  void addToCartFromDialog({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        changeQuantitySubject.add(ApiResponse.loading());
        _repo
            .addToCartWithQuantity(
                productId, int.parse(dialogBoxController.text))
            .then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
            Navigator.of(context, rootNavigator: true).pop();
            refreshProductsForQuantity(
                productId, int.parse(dialogBoxController.text));
          } else {
            changeQuantitySubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
              msg: response.data[ApiParam.MESSAGE],
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
            );
          }
        }).onError((DioException error, stackTrace) {
          changeQuantitySubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(
              backgroundColor: ConstantColors.appBlackColor,
              textColor: ConstantColors.appWhiteColor,
              msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        changeQuantitySubject.add(ApiResponse.error(error.toString()));

        log("${error.toString()}\n$stackTrace", name: "ADD_TO_CART_LOG");
      }
    } else {
      changeQuantitySubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));

      Fluttertoast.showToast(
          backgroundColor: ConstantColors.appBlackColor,
          textColor: ConstantColors.appWhiteColor,
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  void removeFromCart({required int productId}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        addOrRemoveSubject.add(ApiResponse.loading());
        _repo.removeFromCart(productId).then((response) {
          if (response.data['status_code'] == 200) {
            Fluttertoast.showToast(
                backgroundColor: ConstantColors.appBlackColor,
                textColor: ConstantColors.appWhiteColor,
                msg: response.data[ConstantStrings.MESSAGE]);
            refreshProducts(productId, false);
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
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        addOrRemoveSubject.add(ApiResponse.error(error.toString()));
        log("${error.toString()}\n$stackTrace", name: "REMOVE_FROM_CART_LOG");
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

  loadMoreProducts(int pageNo) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        _repo.getProducts(pageNo).then((response) {
          if (response.data['status_code'] == 200) {
            ProductModel productModel = productListSubject.value.data!;
            productModel.allProducts
                .addAll(ProductModel.fromJson(response.data).allProducts);
            productListSubject
                .add(ApiResponse<ProductModel>.completed(productModel));
            loadMore.add(false);
          } else {
            loadMore.add(false);
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          loadMore.add(false);

          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "LOAD MORE PRODUCT LOG");

        loadMore.add(false);
      }
    } else {
      loadMore.add(false);

      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  loadMoreSearchProducts(int pageNo, String text) async {
    log(text, name: "title for search");
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        _repo
            .searchProducts(pageNo, text, getSelectedCategoryIds())
            .then((response) {
          if (response.data['status_code'] == 200) {
            ProductModel productModel = searchListSubject.value.data!;
            productModel.allProducts
                .addAll(ProductModel.fromJson(response.data).allProducts);
            searchListSubject
                .add(ApiResponse<ProductModel>.completed(productModel));
            loadMore.add(false);
          } else {
            loadMore.add(false);
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          loadMore.add(false);

          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "LOAD MORE PRODUCT LOG");

        loadMore.add(false);
      }
    } else {
      loadMore.add(false);

      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  List<int> getSelectedCategoryIds() {
    final selectedCategoryIds = HashSet<int>();
    if (categories.hasValue) {
      for (final category in categories.value.data!.categories) {
        if (category.isSelected) {
          selectedCategoryIds.add(category.id);
        }
      }
    } else {
      selectedCategoryIds.clear();
    }
    return selectedCategoryIds.toList();
  }

  searchProducts(String title) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      searchListSubject.add(ApiResponse.loading());
      try {
        _repo
            .searchProducts(searchPageNo, title, getSelectedCategoryIds())
            .then((response) {
          log(title + " " + response.toString(), name: "Response");
          if (response.data['status_code'] == 200) {
            searchListSubject.add(
                ApiResponse.completed(ProductModel.fromJson(response.data)));
            searchTotalPage = response.data["total_pages"];
          } else {
            searchListSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          searchListSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");

        searchListSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      searchListSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  searchProductsWithPageNoOne(String title) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      searchListSubject.add(ApiResponse.loading());
      try {
        _repo
            .searchProducts(1, title, getSelectedCategoryIds())
            .then((response) {
          log(searchPageNo.toString(), name: "pageNo");
          log(title + " " + response.toString(), name: "Response");
          if (response.data['status_code'] == 200) {
            searchListSubject.add(
                ApiResponse.completed(ProductModel.fromJson(response.data)));
            searchTotalPage = response.data["total_pages"];
          } else {
            searchListSubject
                .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
            Fluttertoast.showToast(
                msg: response.data[ApiParam.MESSAGE],
                backgroundColor: ConstantColors.appWhiteColor);
          }
        }).onError((DioException error, stackTrace) {
          searchListSubject.add(ApiResponse.error(error.message));
          Fluttertoast.showToast(msg: error.message.toString());
        });
      } catch (error, stackTrace) {
        log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");

        searchListSubject.add(ApiResponse.error(error.toString()));
      }
    } else {
      searchListSubject.add(
          ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
      Fluttertoast.showToast(
          msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
    }
  }

  @override
  void dispose() async {}

  void loadCategories() async {
    if (!categories.hasValue) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        searchListSubject.add(ApiResponse.loading());
        try {
          _repo.getCategories().then((response) {
            log(response.toString(), name: "Categories");
            if (response.data['status_code'] == 200) {
              categories.add(
                  ApiResponse.completed(Categories.fromJson(response.data)));
            } else {
              categories
                  .add(ApiResponse.error(response.data[ApiParam.MESSAGE]));
              Fluttertoast.showToast(
                  msg: response.data[ApiParam.MESSAGE],
                  backgroundColor: ConstantColors.appWhiteColor);
            }
          }).onError((DioException error, stackTrace) {
            categories.add(ApiResponse.error(error.message));
            Fluttertoast.showToast(msg: error.message.toString());
          });
        } catch (error, stackTrace) {
          log("${error.toString()}\n$stackTrace", name: "PRODUCT_LIST_LOG");

          categories.add(ApiResponse.error(error.toString()));
        }
      } else {
        categories.add(
            ApiResponse.error(ConstantStrings.INTERNET_CONNECTION_LOST_TITLE));
        Fluttertoast.showToast(
            msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
      }
    }
  }

  void selectCategory(int i) {
    List<Category> cat = List.from(categories.value.data!.categories);
    cat[i] = cat[i].copyWith(isSelected: !cat[i].isSelected);
    categories.add(ApiResponse.completed(
        categories.value.data!.copyWith(categories: cat)));
  }

  void clearSelectedCategories() {
    searchPageNo = 1;
    var tempList = categories.value.data!.categories;
    for (var element in tempList) {
      element.isSelected = false;
    }
    categories.add(ApiResponse.completed(
        categories.value.data!.copyWith(categories: tempList)));
    onSearchFieldSubmitted(
        v: searchController.text, isFiltered: true, isCategories: false);
  }
}
