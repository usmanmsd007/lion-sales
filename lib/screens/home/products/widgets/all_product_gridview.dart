
import 'package:flutter/material.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/screens/home/products/widgets/product_widget.dart'; 
import 'package:lion_sales/utils/extensions.dart';

class AllProductsGridView extends StatelessWidget {
  const AllProductsGridView({
    super.key,
    required ProductBloc? bloc,
    required this.productModel,
    required this.isLoadingTwo,
  }) : _bloc = bloc;

  final ProductBloc? _bloc;
  final ProductModel productModel;
  final bool isLoadingTwo;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        controller: _bloc!.allProductGridController,
        itemCount: productModel.allProducts.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(
            left: context.width / 20,
            right: context.width / 20,
            bottom: context.height / 15,
            top: context.height / 40),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (context.height / 50) / (context.height / 35.6),
            crossAxisSpacing: context.width / 15,
            mainAxisSpacing: context.height / 30),
        itemBuilder: (c, i) => ProductWidget(
              isLoadingTwo: isLoadingTwo,
              model: productModel.allProducts[i],
              bloc: _bloc!,
            ));
  }
}
