import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_button.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/product_details/product_details_bloc.dart';
import 'package:lion_sales/screens/home/product_details/product_details_dl.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../networking/api_response.dart';
import '../../../reusable_widgets/appBar/custom_appbar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, Object> args;
  const ProductDetailScreen({super.key, required this.args});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailsBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      _bloc = ProductDetailsBloc(context, this);
      _bloc.onGetProductsDetails(
          id: int.parse(widget.args[ConstantStrings.PRODUCT_ID].toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ConstantColors.appWhiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showBackButton: true,
          onTap: () {
            Navigator.pop(context);
          },
          title: ConstantStrings.PRODUCT_DETAILS,
        ),
      ),
      body: Body(
        bloc: _bloc,
      ),
    ));
  }
}

class Body extends StatelessWidget {
  const Body({super.key, required ProductDetailsBloc bloc}) : _bloc = bloc;
  final ProductDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ProductDetailModel>>(
        stream: _bloc.productDetailSubject,
        initialData: ApiResponse.loading(),
        builder: (context, snapshot) {
          bool isLoading = false;
          if (!snapshot.hasError) {
            isLoading =
                snapshot.hasData && snapshot.data?.status == Status.loading;
          }
          return snapshot.data!.status == Status.error
              ? Center(child: Text(snapshot.data!.message!))
              : isLoading
                  ? const Center(
                      child: AppLoadingWidget(),
                    )
                  : ProductDetailsWidget(
                      bloc: _bloc,
                      productDetailModel: snapshot.data!.data!.productDetail);
        });
  }
}

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({
    super.key,
    required this.bloc,
    required ProductDetail productDetailModel,
  }) : _productDetailModel = productDetailModel;
  final ProductDetail _productDetailModel;
  final ProductDetailsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width / 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width / 15),
              child: Column(
                children: [
                  SizedBox(
                    height: context.height / 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.appPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.width / 30,
                              vertical: context.height / 150),
                          child: const Text("New"),
                        ),
                      ),
                      const Icon(Icons.heart_broken_sharp)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        _productDetailModel.imagePath,
                        width: context.width / 2,
                        height: context.width / 3,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.height / 30,
                  ),
                  Text(
                    _productDetailModel.title,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: poppinsTextStyle(
                        fontSize: 17, textColor: ConstantColors.appBlackColor),
                  ),
                  SizedBox(
                    height: context.height / 200,
                  ),
                  Text(
                    "UPC : ${_productDetailModel.upc}",
                    overflow: TextOverflow.clip,
                    style: poppinsTextStyle(
                        fontSize: 17, textColor: ConstantColors.colorGreyText),
                  ),
                  SizedBox(
                    height: context.height / 200,
                  ),
                  Text(
                    "\$${_productDetailModel.price}",
                    overflow: TextOverflow.clip,
                    style: poppinsTextStyle(
                        fontSize: 20,
                        textColor: ConstantColors.appPrimaryColor),
                  ),
                  StreamBuilder<ApiResponse>(
                      stream: bloc.addOrRemoveSubject,
                      builder: (context, addToCart) {
                        bool isLoadingThree = addToCart.hasData &&
                            addToCart.data!.status == Status.loading;
                        return isLoadingThree
                            ? const Center(child: AppLoadingWidget())
                            : StreamBuilder<bool>(
                                initialData: false,
                                stream: bloc.isAlreadyAdded,
                                builder: (context, isAlreadyInCart) {
                                  return isAlreadyInCart.data!
                                      ? const Text("Added to Cart")
                                      : AppButtonTwo(
                                          height: context.height / 20,
                                          width: context.width / 1.5,
                                          onTap: () {
                                            bloc.addToCart(
                                                productId:
                                                    _productDetailModel.id);
                                          },
                                          text: "Add to cart");
                                });
                      })
                ],
              ),
            ),
            SizedBox(
              height: context.height / 30,
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: ConstantColors.colorGrey),
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.height / 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Company: ",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Text("Lion Solution")
                  ],
                ),
              ),
            ),
            ProductDetailsTable(productDetailModel: _productDetailModel),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                top: BorderSide(color: ConstantColors.colorGrey),
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.height / 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dimension: ",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(_productDetailModel.dimension)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsTable extends StatelessWidget {
  const ProductDetailsTable({
    super.key,
    required ProductDetail productDetailModel,
  }) : _productDetailModel = productDetailModel;

  final ProductDetail _productDetailModel;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        right: BorderSide(
          color: ConstantColors.appBlackColor,
        ),
        left: BorderSide(
          color: ConstantColors.appBlackColor,
        ),
        verticalInside: BorderSide(
          color: ConstantColors.colorGrey,
        ),
        horizontalInside: BorderSide(
          color: ConstantColors.colorGrey,
        ),
      ),
      children: [
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text(
                    "SAP#",
                    style: poppinsTextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(
                    _productDetailModel.sap,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text("AC#",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(_productDetailModel.ac),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text(
                    "SRP#",
                    style: poppinsTextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(
                    _productDetailModel.srp,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text("SIZE",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(_productDetailModel.size),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text(
                    "CASE",
                    style: poppinsTextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(
                    _productDetailModel.prodCase,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text("Pallet",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(_productDetailModel.pallet),
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text(
                    "Layer",
                    style: poppinsTextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(
                    _productDetailModel.layer,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 100),
                  child: Text("Weight",
                      style: poppinsTextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.height / 70),
                  child: Text(_productDetailModel.weight),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
