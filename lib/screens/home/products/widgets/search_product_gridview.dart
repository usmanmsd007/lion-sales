import 'package:flutter/material.dart';
import 'package:lion_sales/networking/api_response.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';
import 'package:lion_sales/screens/home/products/product_dl.dart';
import 'package:lion_sales/screens/home/products/widgets/product_widget.dart';
import 'package:lion_sales/utils/extensions.dart';

class SearchProductsGridView extends StatelessWidget {
  const SearchProductsGridView({
    super.key,
    required ProductBloc? bloc,
  }) : _bloc = bloc;

  final ProductBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ProductModel>>(
        initialData: ApiResponse.loading(),
        stream: _bloc!.searchListSubject,
        builder: (context, snapshot) {
          bool isLoading = false;
          if (!snapshot.hasError) {
            isLoading =
                snapshot.hasData && snapshot.data?.status == Status.loading;
          }
          String originalString = snapshot.data!.message ?? "";
          String newString = originalString.isEmpty
              ? ""
              : originalString.replaceFirst("products", "product");
          return snapshot.data!.status == Status.error
              ? Center(child: Text(newString))
              : isLoading
                  ? const Center(child: AppLoadingWidget())
                  : snapshot.data!.data!.allProducts.isEmpty
                      ? const Text("Sorry! No result found")
                      : SizedBox(
                          height: context.height - (context.height / 4.5),
                          child: GridView.builder(
                              controller: _bloc!.searchProductGridController,
                              itemCount:
                                  snapshot.data!.data!.allProducts.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  left: context.width / 20,
                                  right: context.width / 20,
                                  bottom: context.height / 15,
                                  top: context.height / 40),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: (context.height / 50) /
                                          (context.height / 35.6),
                                      crossAxisSpacing: context.width / 15,
                                      mainAxisSpacing: context.height / 30),
                              itemBuilder: (c, i) => ProductWidget(
                                    isLoadingTwo: isLoading,
                                    model: snapshot.data!.data!.allProducts[i],
                                    bloc: _bloc!,
                                  )),
                        );
        });
  }
}
