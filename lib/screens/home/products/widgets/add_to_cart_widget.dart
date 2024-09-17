
import 'package:flutter/material.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';

class AddToCardWidget extends StatelessWidget {
  const AddToCardWidget({
    super.key,
    required ProductBloc bloc,
    required this.id,
  }) : _bloc = bloc;
  final ProductBloc _bloc;
  final int id;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _bloc.addToCart(productId: id);
      },
      child: Container(
        alignment: Alignment.center,
        width: context.width / 2,
        decoration: BoxDecoration(
            color: ConstantColors.colorAddToCart,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ConstantColors.colorGreyLight, width: 1)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width / 80, vertical: context.height / 200),
          child: const Text(
            ConstantStrings.ADD_TO_CART,
            style: TextStyle(
              color: ConstantColors.appWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}