import 'package:flutter/material.dart';
import 'package:lion_sales/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:lion_sales/screens/auth/login/login_screen.dart';
import 'package:lion_sales/screens/auth/register/register_screen.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_screen.dart';
import 'package:lion_sales/screens/home/dashboard/dashboard_screen.dart';
import 'package:lion_sales/screens/home/invoice_screen/invoice_screen.dart';
import 'package:lion_sales/screens/home/orders/orders_screen.dart';
import 'package:lion_sales/screens/home/product_details/product_details_screen.dart';
import 'package:lion_sales/screens/update_app/update_screen.dart';

import '../screens/splash/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args =
        settings.arguments as Map<String, Object>? ?? <String, Object>{};

    switch (settings.name) {
      case AppRoutes.DEFAULT:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case AppRoutes.LOGIN_SCREEN:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
 case AppRoutes.UPDATE_APP_SCREEN:
        return MaterialPageRoute(builder: (context) => const UpdateScreen());

      case AppRoutes.REGISTER_SCREEN:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case AppRoutes.FORGOT_PASSWORD_SCREEN:
        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordScreen());
      case AppRoutes.DASHBOARD_SCREEN:
        return MaterialPageRoute(builder: (context) => const DashboardScreen());
      case AppRoutes.BOTTOM_NAV_SCREEN:
        return MaterialPageRoute(
            builder: (context) => BottomNavScreen(
                  index: 10,
                ));
      case AppRoutes.ORDER_SCREEN:
        return MaterialPageRoute(builder: (context) => const OrdersScreen());
      case AppRoutes.INVOICE_SCREEN:
        return MaterialPageRoute(
            builder: (context) => InvoiceScreen(
                  args: args,
                ));
      case AppRoutes.PRODUCT_DETAILS:
        return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                  args: args,
                ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'This is not the page you are looking for',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Trajan',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}
