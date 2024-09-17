
import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';

class ProductLoading extends StatelessWidget {
  const ProductLoading({
    super.key,
    required ProductBloc? bloc,
  }) : _bloc = bloc;

  final ProductBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _bloc!.loadMore,
        builder: (c, s) {
          return s.data!
              ?   const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLoadingWidget(),
                  ],
                )
              : const SizedBox.shrink();
        });
  }
}