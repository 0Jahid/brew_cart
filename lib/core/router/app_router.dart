import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/coffee_shop/presentation/pages/coffee_shop_page.dart';
import '../features/coffee_details/presentation/pages/coffee_details_page.dart';
import '../features/customization/presentation/pages/customization_page.dart';
import '../features/checkout/presentation/pages/checkout_page.dart';
import '../features/order_tracking/presentation/pages/order_tracking_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String coffeeDetails = '/coffee-details';
  static const String customization = '/customization';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const CoffeeShopPage(),
      ),
      GoRoute(
        path: coffeeDetails,
        builder: (context, state) {
          final coffeeId = state.uri.queryParameters['id']!;
          return CoffeeDetailsPage(coffeeId: coffeeId);
        },
      ),
      GoRoute(
        path: customization,
        builder: (context, state) {
          final coffeeId = state.uri.queryParameters['id']!;
          return CustomizationPage(coffeeId: coffeeId);
        },
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: orderTracking,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['id']!;
          return OrderTrackingPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
