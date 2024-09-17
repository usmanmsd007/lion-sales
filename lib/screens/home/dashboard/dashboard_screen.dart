import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lion_sales/my_locator.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:lion_sales/utils/constant_images.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../networking/api_response.dart';
import '../../../utils/constant_colors.dart';
import 'dashboard_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, this.currentIndex}) : super(key: key);
  final int? currentIndex;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardBloc? _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (widget.currentIndex == 0) {
        _bloc = DashboardBloc(context, this)
          ..getTotalProduct()
          ..getTotalOrders();
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
        : SafeArea(
            child: Scaffold(
                // resizeToAvoidBottomInset: false,
                backgroundColor: ConstantColors.colorBackGroundHome,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: context.height / 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ConstantImages.DASHBOARD_ONE),
                          SizedBox(
                            width: context.width / 15,
                          ),
                          Image.asset(ConstantImages.DASHBOARD_TWO),
                          SizedBox(
                            width: context.width / 15,
                          ),
                          Image.asset(ConstantImages.DASHBOARD_THREE),
                        ],
                      ),
                      SizedBox(
                        height: context.height / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const IndicatorWidget(),
                          SizedBox(
                            width: context.width / 20,
                          ),
                          const IndicatorWidget(),
                        ],
                      ),
                      SizedBox(
                        height: context.height / 10,
                      ),
                      StreamBuilder<ApiResponse<int>>(
                          initialData: ApiResponse.loading(),
                          stream: _bloc!.totalOrderSubject,
                          builder: (context, totalOrderSnap) {
                            bool isLoading = false;
                            if (!totalOrderSnap.hasError) {
                              isLoading = totalOrderSnap.hasData &&
                                  totalOrderSnap.data?.status == Status.loading;
                            }
                            return totalOrderSnap.data!.status == Status.error
                                ? Center(
                                    child: Text(totalOrderSnap.data!.message!))
                                : isLoading
                                    ? const Center(child: AppLoadingWidget())
                                    : Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              var bottomNavBloc =
                                                  locator.get<BottomNavBloc>();
                                              bottomNavBloc.addIndex(1);
                                            },
                                            child: DashboardTileComponent(
                                                iconPath:
                                                    'assets/images/total_orders.svg',
                                                total: totalOrderSnap
                                                    .data!.data!
                                                    .toString(),
                                                title: ConstantStrings
                                                    .TOTAL_ORDER),
                                          ),
                                          SizedBox(
                                            height: context.height / 40,
                                          ),
                                          StreamBuilder<ApiResponse<int>>(
                                              initialData:
                                                  ApiResponse.loading(),
                                              stream:
                                                  _bloc!.totalProductSubject,
                                              builder:
                                                  (context, totalProductSnap) {
                                                bool isLoading = false;
                                                if (!totalProductSnap
                                                    .hasError) {
                                                  isLoading = totalProductSnap
                                                          .hasData &&
                                                      totalProductSnap
                                                              .data?.status ==
                                                          Status.loading;
                                                }
                                                return totalProductSnap
                                                            .data!.status ==
                                                        Status.error
                                                    ? Center(
                                                        child: Text(
                                                            totalProductSnap
                                                                .data!
                                                                .message!))
                                                    : isLoading
                                                        ? const Center(
                                                            child:
                                                                AppLoadingWidget())
                                                        : GestureDetector(
                                                            onTap: () {
                                                              var bottomNavBloc =
                                                                  locator.get<
                                                                      BottomNavBloc>();
                                                              bottomNavBloc
                                                                  .addIndex(2);
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (c) =>
                                                              //             TotalProductScreen()));
                                                            },
                                                            child: DashboardTileComponent(
                                                                iconPath:
                                                                    'assets/images/total_products.svg',
                                                                total: totalProductSnap
                                                                    .data!.data!
                                                                    .toString(),
                                                                title: ConstantStrings
                                                                    .TOTAL_PRODUCTS),
                                                          );
                                              }),
                                        ],
                                      );
                          })
                    ],
                  ),
                )),
          );
  }
}

class DashboardTileComponent extends StatelessWidget {
  const DashboardTileComponent(
      {super.key,
      required this.iconPath,
      required this.total,
      required this.title});
  final String iconPath;
  final String title;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.9,
      height: context.height * 0.16,
      decoration: BoxDecoration(
          color: ConstantColors.appBlackColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(
            width: context.width / 20,
          ),
          SvgPicture.asset(iconPath),
          SizedBox(
            width: context.width / 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: poppinsTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.width * 0.04,
                    textColor: ConstantColors.appPrimaryColor),
              ),
              Text(
                total,
                style: poppinsTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.width * 0.08,
                    textColor: ConstantColors.appPrimaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.025,
      height: context.width * 0.025,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: ConstantColors.colorIndicator),
    );
  }
}
