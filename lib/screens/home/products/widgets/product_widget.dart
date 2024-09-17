import 'package:flutter/material.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/screens/home/products/widgets/add_or_remove_widget.dart';
import 'package:lion_sales/screens/home/products/widgets/add_to_cart_widget.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget(
      {super.key,
      required this.model,
      required this.isLoadingTwo,
      required ProductBloc bloc})
      : _bloc = bloc;
  final bool isLoadingTwo;
  final AllProductModel model;
  final ProductBloc _bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.height / 3.4,
        width: context.width / 8,
        decoration: BoxDecoration(
            color: ConstantColors.appWhiteColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey,
                  spreadRadius: 1,
                  offset: Offset(0, 2)),
              BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey,
                  spreadRadius: 1,
                  offset: Offset(2, 0)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                _bloc.gotoProductDetailsScreen(id: model.id);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: context.height / 20,
                  ),
                  SizedBox(
                    height: context.height / 10,
                    child: Image.network(
                      model.imagePath,
                      width: context.width / 5,
                      fit: BoxFit.fitHeight,
                      height: context.height / 10,
                    ),
                  ),
                  Text(
                    "\$${model.price}",
                    style: poppinsTextStyle(
                        textColor: ConstantColors.appPrimaryColor),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: context.width / 50),
                    child: Text(
                      model.title,
                      style: poppinsTextStyle(
                        textColor: ConstantColors.appBlackColor,
                        fontSize: 9,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: context.height / 90,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: context.width / 70,
                  right: context.width / 70,
                  bottom: context.height / 100),
              child: model.quantity > 0
                  ? AddRemoveWidget(
                      isLoadingTwo: isLoadingTwo, model: model, bloc: _bloc)
                  : AddToCardWidget(
                      bloc: _bloc,
                      id: model.id,
                    ),
            )
          ],
        ));
  }
}
