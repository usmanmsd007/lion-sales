// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lion_sales/my_locator.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/custom_icons.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../utils/utils.dart';

class BottomNavScreen extends StatefulWidget {
  BottomNavScreen({Key? key, this.index = 0}) : super(key: key);
  int index;
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late BottomNavBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) { 
      _bloc = locator.get<BottomNavBloc>();
      if (widget.index == 10) {
        widget.index = 0;
        _bloc.controller.jumpToTab(widget.index);
      }
      if (widget.index > 0) {
        _bloc.controller.jumpToTab(widget.index);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  var icons = [
    PersistentBottomNavBarItem(
        activeColorPrimary: ConstantColors.appPrimaryColor,
        inactiveColorPrimary: ConstantColors.appPrimaryColor,
        icon: const Icon(
          CustomIcons.dashboard_1,
        ),
        textStyle: poppinsTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            textColor: ConstantColors.appWhiteColor),
        title: ConstantStrings.DASHBOARD),
    PersistentBottomNavBarItem(
        activeColorPrimary: ConstantColors.appPrimaryColor,
        inactiveColorPrimary: ConstantColors.appPrimaryColor,
        textStyle: poppinsTextStyle(
            fontWeight: FontWeight.bold,
            textColor: ConstantColors.appWhiteColor,
            fontSize: 11),
        icon: const Icon(
          CustomIcons.dashboard_2,
        ),
        title: ConstantStrings.ORDERS),
    PersistentBottomNavBarItem(
        activeColorPrimary: ConstantColors.appPrimaryColor,
        inactiveColorPrimary: ConstantColors.appPrimaryColor,
        icon: const Icon(
          CustomIcons.dashboard_3,
        ),
        textStyle: poppinsTextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          textColor: ConstantColors.appWhiteColor,
        ),
        title: ConstantStrings.PRODUCTS),
    PersistentBottomNavBarItem(
        activeColorPrimary: ConstantColors.appPrimaryColor,
        inactiveColorPrimary: ConstantColors.appPrimaryColor,
        icon: const Icon(
          CustomIcons.dashboard_4,
        ),
        textStyle: poppinsTextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          textColor: ConstantColors.appWhiteColor,
        ),
        title: ConstantStrings.CART),
    PersistentBottomNavBarItem(
        activeColorPrimary: ConstantColors.appPrimaryColor,
        inactiveColorPrimary: ConstantColors.appPrimaryColor,
        icon: const Icon(
          Icons.settings,
        ),
        textStyle: poppinsTextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          textColor: ConstantColors.appWhiteColor,
        ),
        title: ConstantStrings.SETTINGS),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: context.width / 1.5,
                      child: const Text('Are you sure you want to close the app?', maxLines:  2,)),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Yes',
                    style: poppinsTextStyle(
                      textColor: ConstantColors.appPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: context.width / 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'No',
                    style: poppinsTextStyle(
                      textColor: ConstantColors.appPrimaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: SafeArea(
        child: StreamBuilder<int>(
            stream: _bloc.currentIndex,
            initialData: 0,
            builder: (context, snapshot) {
              return Scaffold(
                  backgroundColor: ConstantColors.appWhiteColor,
                  body: _bloc.screens(snapshot.data!)[snapshot.data!],
                  bottomNavigationBar: PersistentTabView(
                    
                    context,
                    stateManagement: false,
                    controller: _bloc.controller,

                    screens: _bloc.screens(snapshot.data!),
                    items: icons,
                    resizeToAvoidBottomInset: true,
                    navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 0.0
                        : kBottomNavigationBarHeight,
                    bottomScreenMargin: 0,
                    backgroundColor: ConstantColors.appWhiteColor,
                    screenTransitionAnimation: const ScreenTransitionAnimation(
                      animateTabTransition: true,
                    ),
                    onItemSelected: (i) {
                      _bloc.currentIndex.add(i);
                    },
                    navBarStyle: NavBarStyle
                        .style1, // Choose the nav bar style with this property
                  ));
            }),
      ),
    );
  }
}
