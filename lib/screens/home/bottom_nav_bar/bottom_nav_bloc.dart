import 'package:flutter/material.dart';
import 'package:lion_sales/screens/home/cart/cart_screen.dart';
import 'package:lion_sales/screens/home/dashboard/dashboard_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../blocs/bloc.dart';
import '../orders/orders_screen.dart';
import '../products/product_screen.dart';
import '../settings/setting_screen.dart';

class BottomNavBloc extends Bloc {
  final BehaviorSubject<int> _currentIndex = BehaviorSubject<int>.seeded(0);

  BehaviorSubject<int> get currentIndex => _currentIndex;

  addIndex(int i) {
    controller.index = i;
    currentIndex.add(i);
  }

  jumpTo(int i) {
    // controller.index = i;
    controller.jumpToTab(i);
  }

  List<Widget> screens(int i) {
    return [
      DashboardScreen(
        currentIndex: i,
      ),
      OrdersScreen(
        currentIndex: i,
      ),
      ProductScreen(
        currentIndex: i,
      ),
      CartScreen(
        currentIndex: i,
      ),
      const SettingScreen(),
    ];
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  @override
  void dispose() async {
    await _currentIndex.done;
  }
}
