import 'package:flutter/material.dart';
import 'package:lion_sales/networking/api_response.dart';
import 'package:lion_sales/reusable_widgets/app_text_field.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

class AddRemoveWidget extends StatelessWidget {
  const AddRemoveWidget({
    super.key,
    required this.isLoadingTwo,
    required this.model,
    required ProductBloc bloc,
  }) : _bloc = bloc;

  final bool isLoadingTwo;
  final AllProductModel model;
  final ProductBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: isLoadingTwo
                ? () {}
                : () {
                    if (model.quantity > 0) {
                      _bloc.removeFromCart(productId: model.id);
                    }
                  },
            child: Container(
              decoration: const BoxDecoration(
                  color: ConstantColors.colorGreyLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              // height: context.height / 30,
              child: Padding(
                padding: EdgeInsets.all(context.width / 100),
                child: Icon(
                  Icons.remove,
                  size: context.width / 25,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (c) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Change Quantity",
                                style: poppinsTextStyle(
                                    fontSize: context.width * 0.05,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: context.height / 40,
                              ),
                              Form(
                                key: _bloc.dialogBoxFormKey,
                                child: MyTextField(
                                    onFieldSubmitted: (v) {
                                      if (_bloc.dialogBoxFormKey.currentState!
                                          .validate()) {
                                        _bloc.addToCartFromDialog(
                                            productId: model.id);
                                      }
                                    },
                                    textColor: false,
                                    keyboardType: TextInputType.number,
                                    validate: (c) {
                                      if (c!.isEmpty) {
                                        return "Please enter quantity";
                                      } else if (int.parse(c) < 1) {
                                        return "Please enter a valid quantity";
                                      } else {
                                        return null;
                                      }
                                    },
                                    action: TextInputAction.done,
                                    labelText: "Quantity",
                                    controller: _bloc.dialogBoxController
                                      ..text = model.quantity.toString(),
                                    hintText: model.quantity.toString()),
                              ),
                              SizedBox(
                                height: context.height / 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text(
                                      "Close",
                                      style: poppinsTextStyle(
                                          textColor:
                                              ConstantColors.appBlackColor,
                                          fontSize: context.width * 0.04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  StreamBuilder<ApiResponse>(
                                      stream: _bloc.changeQuantitySubject,
                                      initialData: ApiResponse.completed(),
                                      builder: (context, snapshot) {
                                        return snapshot.data!.status ==
                                                Status.loading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: ConstantColors
                                                      .appPrimaryColor,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  if (_bloc.dialogBoxFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    _bloc.addToCartFromDialog(
                                                        productId: model.id);
                                                  }
                                                },
                                                child: Text(
                                                  "Change",
                                                  style: poppinsTextStyle(
                                                      textColor: ConstantColors
                                                          .appPrimaryColor,
                                                      fontSize:
                                                          context.width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
            },
            child: Container(
              width: context.width / 4.1,
              height: context.height / 40,
              alignment: Alignment.center,
              child: Text(model.quantity.toString()),
            ),
          ),
          GestureDetector(
            onTap: isLoadingTwo
                ? () {}
                : () {
                    _bloc.addToCart(productId: model.id);
                  },
            child: Container(
              // height: context.height / 40,
              decoration: const BoxDecoration(
                  color: ConstantColors.colorGreen,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              // height: context.height / 40,
              child: Padding(
                padding: EdgeInsets.all(context.width / 100),
                child: Icon(
                  Icons.add,
                  size: context.width / 25,
                  color: ConstantColors.appWhiteColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
