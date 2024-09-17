import 'package:flutter/material.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/orders/orders_dl.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../utils/constant_colors.dart';
import '../invoice_screen/invoice_screen.dart';
import 'orders_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, this.currentIndex}) : super(key: key);
  final int? currentIndex;
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrdersBloc? _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (widget.currentIndex == 1) {
        _bloc = OrdersBloc(context, this)..onGetCartList();
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
  Widget build(BuildContext ctx) {
    return _bloc == null
        ? const SizedBox.shrink()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                showBackButton: false,
                onTap: () {},
                title: ConstantStrings.ORDERS,
              ),
            ),
            body: StreamBuilder<ApiResponse<OrderListModel>>(
                initialData: ApiResponse.loading(),
                stream: _bloc!.orderSubject,
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
                          : snapshot.data!.data!.orderListData.isEmpty
                              ? const Center(
                                  child: Text(ConstantStrings.NO_ORDER_FOUND),
                                )
                              : ListView(
                                  children: [
                                    ...List.generate(
                                      snapshot.data!.data!.orderListData.length,
                                      (i) => OrderTileComponent(
                                        orderModel: snapshot
                                            .data!.data!.orderListData[i],
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) => InvoiceScreen(
                                                        args: {
                                                          ConstantStrings
                                                                  .ORDER_ID:
                                                              snapshot
                                                                  .data!
                                                                  .data!
                                                                  .orderListData[
                                                                      i]
                                                                  .orderId
                                                                  .toString()
                                                        },
                                                      )));
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: context.height / 10,
                                    )
                                  ],
                                );
                }),
          );
  }
}

class OrderTileComponent extends StatelessWidget {
  const OrderTileComponent(
      {super.key, required this.onTap, required this.orderModel});
  final VoidCallback onTap;
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width / 30, vertical: context.height / 100),
        child: Card(
          elevation: 5,
          color: ConstantColors.colorGreyLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.height / 40, horizontal: context.width / 18),
            child: IntrinsicHeight(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width / 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ConstantStrings.ID_NO +
                                  orderModel.orderId.toString(),
                              style: poppinsTextStyle(
                                  textColor: ConstantColors.appPrimaryColor,
                                  fontSize: context.width * 0.035),
                            ),
                            Text(orderModel.userName,
                                style: poppinsTextStyle(
                                    fontWeight: FontWeight.bold,
                                    textColor: ConstantColors.appBlackColor,
                                    fontSize: context.width * 0.04)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ConstantStrings.TOTAL,
                          style: poppinsTextStyle(
                              textColor: ConstantColors.appPrimaryColor,
                              fontSize: context.width * 0.035)),
                      orderModel.totalAmount.toString().length > 7
                          ? SizedBox(
                              width: context.width / 5,
                              child: Text(orderModel.totalAmount.toString(),
                                  overflow: TextOverflow.clip,
                                  style: poppinsTextStyle(
                                      fontWeight: FontWeight.bold,
                                      textColor: ConstantColors.appBlackColor,
                                      fontSize: context.width * 0.04)),
                            )
                          : Text('\$${orderModel.totalAmount}',
                              overflow: TextOverflow.fade,
                              style: poppinsTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ConstantColors.appBlackColor,
                                  fontSize: context.width * 0.04)),
                      SizedBox(
                        height: context.height / 40,
                      )
                    ],
                  ),
                  Chip(
                    label: Text(
                      orderModel.status.name,
                      // "N/A",
                    ),
                  ),
                  const Icon(
                    Icons.remove_red_eye,
                    color: ConstantColors.appPrimaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
