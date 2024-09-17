import 'package:flutter/material.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/screens/home/invoice_screen/invoice_dl.dart';
import 'package:lion_sales/utils/extensions.dart';

import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../reusable_widgets/app_loading_widget.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/utils.dart';
import 'invoice_bloc.dart';

class InvoiceScreen extends StatefulWidget {
  final Map<String, Object> args;
  const InvoiceScreen({
    super.key,
    required this.args,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late InvoiceBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      _bloc = InvoiceBloc(context, this)
        ..getInvoiceDetails(
            orderId:
                int.parse(widget.args[ConstantStrings.ORDER_ID].toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.args[ConstantStrings.ORDER_ID].toString();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            showBackButton: true,
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Invoice # $id',
          )),
      body: StreamBuilder<ApiResponse<InvoiceModel>>(
          stream: _bloc.invoiceSubject,
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
                    ? const Center(child: AppLoadingWidget())
                    : ListView(
                        children: [
                          InvoiceHeader(
                            invoiceModel: snapshot.data!.data!.data,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ConstantStrings.ORDER_PRODUCTS,
                                style: poppinsTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.width * 0.065),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: context.height / 100,
                          ),
                          ...List.generate(
                              snapshot.data!.data!.data.products.length,
                              (index) => Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.width / 25,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  ConstantColors.colorGreyLight,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                context.width / 40),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          context.width / 1.4,
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .data
                                                            .products[index]
                                                            .productTitle,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: poppinsTextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              context.width *
                                                                  0.07,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _bloc.gotoProductScreen(
                                                            id: snapshot
                                                                .data!
                                                                .data!
                                                                .data
                                                                .products[index]
                                                                .productId);
                                                      },
                                                      child: const Icon(
                                                        Icons.info_outline,
                                                        color: ConstantColors
                                                            .appPrimaryColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ConstantStrings
                                                              .QUANTITY,
                                                          style: poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                              textColor:
                                                                  ConstantColors
                                                                      .appPrimaryColor),
                                                        ),
                                                        Text(
                                                          ConstantStrings.UPC,
                                                          style: poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                              textColor:
                                                                  ConstantColors
                                                                      .appPrimaryColor),
                                                        ),
                                                        Text(
                                                          ConstantStrings
                                                              .ITEM_PRICE,
                                                          style: poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                              textColor:
                                                                  ConstantColors
                                                                      .appPrimaryColor),
                                                        ),
                                                        Text(
                                                          ConstantStrings
                                                              .TOTAL_PRICE,
                                                          style: poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                              textColor:
                                                                  ConstantColors
                                                                      .appPrimaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          context.width / 2.5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .data
                                                                .products[index]
                                                                .productQuantity
                                                                .toString(),
                                                            style:
                                                                poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .data
                                                                .products[index]
                                                                .upc
                                                                .toString(),
                                                            style:
                                                                poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.05,
                                                            ),
                                                          ),
                                                          Text(
                                                            '\$ ${snapshot.data!.data!.data.products[index].price}',
                                                            style:
                                                                poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                            ),
                                                          ),
                                                          Text(
                                                            '\$ ${snapshot.data!.data!.data.products[index].productTotalPrice}',
                                                            style:
                                                                poppinsTextStyle(
                                                              fontSize: context
                                                                      .width *
                                                                  0.065,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.height / 50,
                                      ),
                                    ],
                                  )),
                          SizedBox(
                            height: context.height / 10,
                          )
                        ],
                      );
          }),
    );
  }
}

class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({super.key, required this.invoiceModel});

  final InvoiceData invoiceModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BillToWidget(
          title: invoiceModel.userName,
        ),
        InvoiceHeaderTile(
          header: ConstantStrings.DATE,
          title: invoiceModel.convertDateFormat(invoiceModel.orderUpdateDate),
        ),
        InvoiceHeaderTile(
          header: ConstantStrings.TOTAL_QUANTITY,
          title: invoiceModel.totalQuantity.toString(),
        ),
        InvoiceHeaderTile(
          header: ConstantStrings.TOTAL_PRICE,
          title: '\$${invoiceModel.totalPrice}',
        ),
      ],
    );
  }
}

class InvoiceHeaderTile extends StatelessWidget {
  const InvoiceHeaderTile(
      {super.key, required this.header, required this.title});
  final String header, title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          header,
          style: poppinsTextStyle(fontSize: context.width * 0.05),
        ),
        Text(
          title,
          style: poppinsTextStyle(
              fontSize: context.width * 0.05, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

class BillToWidget extends StatelessWidget {
  const BillToWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: context.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bill To: ",
            style: poppinsTextStyle(fontSize: context.width * 0.05),
            maxLines: 2,
          ),
          SizedBox(
            width: context.width / 1.9,
            child: Text(
              title,
              style: poppinsTextStyle(
                fontSize: context.width * 0.05,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 10,
              overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
    );
  }
}
