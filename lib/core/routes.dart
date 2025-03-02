import 'package:flutter/material.dart';
import 'package:linkjo/screen/add_product_screen.dart';
import 'package:linkjo/screen/dashboard_screen.dart';
import 'package:linkjo/screen/location_picker.dart';
import 'package:linkjo/screen/login_screen.dart';
import 'package:linkjo/screen/order_history_screen.dart';
import 'package:linkjo/screen/register_screen.dart';
import 'package:linkjo/screen/splash_screen.dart';
import 'package:linkjo/screen/statistic_screen.dart';

class Routes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String orderHistory = '/order-history';
  static const String orderDetail = '/order-detail';
  static const String statistic = '/statistic';
  static const String login = '/login';
  static const String register = '/register';
  static const String locationPicker = '/location-picker';
  static const String addProduct = '/add-product';

  static Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (settings) {
    switch (settings.name) {
      case splash:
        return _customPageRoute(const SplashScreen());
      case dashboard:
        return _customPageRoute(const DashboardScreen());
      case orderHistory:
        return _customPageRoute(const OrderHistoryScreen());
      case statistic:
        return _customPageRoute(const StatisticScreen());
      case login:
        return _customPageRoute(const LoginScreen());
      case register:
        return _customPageRoute(const RegisterScreen());
      case locationPicker:
        return _customPageRoute(const LocationPicker());
      case addProduct:
        return _customPageRoute(const AddProductScreen());
      default:
        return null;
    }
  };

  static PageRouteBuilder _customPageRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
