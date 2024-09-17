import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/screens/home/products/widgets/all_product_gridview.dart';
import 'package:lion_sales/screens/home/products/widgets/my_search_textfield.dart';
import 'package:lion_sales/screens/home/products/widgets/product_loading.dart';
import 'package:lion_sales/screens/home/products/widgets/search_product_gridview.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../networking/api_response.dart';
import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../reusable_widgets/app_loading_widget_two.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.currentIndex});
  final int? currentIndex;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc? _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (widget.currentIndex == 2) {
        _bloc = ProductBloc(context, this)
          ..onGetProducts()
          ..addListenerToScrollController();
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_bloc != null) {
      _bloc!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bloc == null
        ? const SizedBox.shrink()
        : SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: CustomAppBar(
                    showBackButton: false,
                    onTap: () {},
                    title: ConstantStrings.PRODUCTS,
                  ),
                ),
                body: StreamBuilder<ApiResponse<ProductModel>>(
                    stream: _bloc!.productListSubject,
                    initialData: ApiResponse.loading(),
                    builder: (context, snapshot) {
                      bool isLoading = false;
                      if (!snapshot.hasError) {
                        isLoading = snapshot.hasData &&
                            snapshot.data?.status == Status.loading;
                      }
                      return snapshot.data!.status == Status.error
                          ? Center(child: Text(snapshot.data!.message!))
                          : isLoading
                              ? const Center(child: AppLoadingWidget())
                              : StreamBuilder<ApiResponse>(
                                  stream: _bloc!.addOrRemoveSubject,
                                  initialData: ApiResponse.completed(),
                                  builder: (context, snapshotTwo) {
                                    bool isLoadingTwo = snapshotTwo.hasData &&
                                        snapshotTwo.data!.status ==
                                            Status.loading;
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                              context.width / 40),
                                          child: Form(
                                            key: _bloc!.searchFormKey,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _bloc!.loadCategories();
                                                    showCategories(context);
                                                  },
                                                  child: const Icon(
                                                    Icons.filter_list_rounded,
                                                    color: ConstantColors
                                                        .appPrimaryColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: context.width / 70,
                                                ),
                                                Expanded(
                                                    child: MySearchTextField(
                                                        bloc: _bloc)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: _bloc!.isSearching,
                                                  builder: (context,
                                                      searchSnapShot) {
                                                    return searchSnapShot.data!
                                                        ? SearchProductsGridView(
                                                            bloc: _bloc,
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        kBottomNavigationBarHeight),
                                                            child: AllProductsGridView(
                                                                bloc: _bloc,
                                                                isLoadingTwo:
                                                                    isLoadingTwo,
                                                                productModel:
                                                                    snapshot
                                                                        .data!
                                                                        .data!),
                                                          );
                                                  }),
                                              Positioned(
                                                bottom:
                                                    kBottomNavigationBarHeight +
                                                        context.height / 100,
                                                left: 0,
                                                right: 0,
                                                child:
                                                    ProductLoading(bloc: _bloc),
                                              ),
                                              SizedBox(
                                                height: context.height / 10,
                                              ),
                                              Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: isLoadingTwo
                                                      ? const AppLoadingWidgetTwo()
                                                      : const SizedBox
                                                          .shrink()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                    }),
              ),
            ),
          );
  }

  Future<dynamic> showCategories(BuildContext context) {
    return showDialog(
        context: context,
        builder: (c) => Dialog(
              child: SizedBox(
                width: context.width / 1.2,
                height: context.height / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: context.height / 40,
                        ),
                        Text(
                          "Categories",
                          style: poppinsTextStyle(
                            textColor: ConstantColors.appBlackColor,
                            fontSize: context.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: context.height / 80,
                        ),
                        StreamBuilder<ApiResponse<Categories>>(
                            stream: _bloc!.categories,
                            initialData: ApiResponse.loading(),
                            builder: (context, snapshot) {
                              return snapshot.data!.status == Status.loading
                                  ? const AppLoadingWidget()
                                  : snapshot.data!.data == null
                                      ? const AppLoadingWidget()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: context.width / 80),
                                          child: Wrap(
                                            spacing: context.width / 80,
                                            children: [
                                              ...List.generate(
                                                  snapshot.data!.data!
                                                      .categories.length,
                                                  (index) => FilterChip(
                                                        selected: snapshot
                                                            .data!
                                                            .data!
                                                            .categories[index]
                                                            .isSelected,
                                                        selectedColor:
                                                            ConstantColors
                                                                .appPrimaryColor,
                                                        label: Text(snapshot
                                                            .data!
                                                            .data!
                                                            .categories[index]
                                                            .name),
                                                        onSelected: (i) {
                                                          _bloc!.selectCategory(
                                                              index);
                                                        },
                                                      )),
                                            ],
                                          ),
                                        );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _bloc!.clearSelectedCategories();
                              },
                              child: Text(
                                "Clear",
                                style: poppinsTextStyle(
                                  fontSize: context.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _bloc!.onSearchFieldSubmitted(
                                    v: _bloc!.searchController.text,
                                    isCategories: true,
                                    isFiltered: true);
                              },
                              child: Text(
                                "Apply",
                                style: poppinsTextStyle(
                                  fontSize: context.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: context.height / 40,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
