import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/total_products/total_products_bloc.dart';
import 'package:lion_sales/screens/home/total_products/total_products_dl.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../networking/api_response.dart';
import '../../../reusable_widgets/appBar/custom_appbar.dart';

class TotalProductScreen extends StatefulWidget {
  const TotalProductScreen({super.key});

  @override
  State<TotalProductScreen> createState() => _TotalProductScreenState();
}

class _TotalProductScreenState extends State<TotalProductScreen> {
  late TotalProductBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = TotalProductBloc(context, this)..onGetProducts();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            showBackButton: true,
            onTap: () {
              Navigator.pop(context);
            },
            title: ConstantStrings.TOTAL_PRODUCTS,
          ),
        ),
        body: StreamBuilder<ApiResponse<TotalProductsModel>>(
            stream: _bloc.totalProductListSubject,
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
                      : snapshot.data!.data!.products.isEmpty
                          ? const Center(
                              child: Text("Zero Products"),
                            )
                          : SizedBox(
                              height: context.height - (context.height / 5),
                              child: GridView.builder(
                                  itemCount:
                                      snapshot.data!.data!.products.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      left: context.width / 20,
                                      right: context.width / 20,
                                      bottom: context.height / 15,
                                      top: context.height / 40),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 7 / 8.7,
                                          crossAxisSpacing: context.width / 15,
                                          mainAxisSpacing: context.height / 30),
                                  itemBuilder: (c, i) => TotalProductWidget(
                                      isLoadingTwo: true,
                                      model: snapshot.data!.data!.products[i])),
                            );
            }),
      ),
    );
  }
}

class TotalProductWidget extends StatelessWidget {
  const TotalProductWidget(
      {super.key, required this.model, required this.isLoadingTwo});
  // : _bloc = bloc;
  final bool isLoadingTwo;
  final Product model;
  // final TotalProductBloc _bloc;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _bloc.gotoProductDetailsScreen(id: model.id);
      },
      child: Container(
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
          child: Padding(
            padding: EdgeInsets.all(context.width / 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: context.height / 80,
                    ),
                    // Image.asset('assets/images/bottle.png')
                    // ,
                    SizedBox(
                      height: context.height / 10,
                      child: Image.network(
                        model.imagePath,
                        width: context.width / 7,
                        fit: BoxFit.fitHeight,
                        height: context.height / 10,
                      ),
                    ),
                    Text(
                      "${model.price}\$",
                      style: poppinsTextStyle(
                          textColor: ConstantColors.appPrimaryColor),
                    ),
                    Text(
                      model.title,
                      style: poppinsTextStyle(
                        textColor: ConstantColors.appBlackColor,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: context.height / 80,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
