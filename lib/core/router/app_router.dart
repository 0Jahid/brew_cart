import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../features/splash/presentation/pages/animated_splash_screen.dart';
import '../../features/splash/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_page_new.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/coffee_shop/presentation/pages/coffee_shop_page.dart';
import '../../features/coffee_details/presentation/pages/coffee_details_page.dart';
import '../../features/customization/presentation/pages/customization_page.dart';
import '../../features/order_tracking/presentation/pages/order_tracking_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  // Alias for legacy reference 'register' used in some pages
  static const String register = signUp;
  static const String home = '/home';
  static const String coffeeDetails = '/coffee-details';
  static const String customization = '/customization';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn =
          state.uri.toString() == login || state.uri.toString() == signUp;
      final onSplashOrOnboarding = 
          state.uri.toString() == splash || state.uri.toString() == onboarding;
      
      // Allow splash and onboarding screens to show regardless of auth state
      if (onSplashOrOnboarding) {
        return null;
      }
      
      if (user == null && !loggingIn) {
        return login;
      }
      if (user != null && loggingIn) {
        return home;
      }
      return null;
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const AnimatedSplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: signUp, builder: (context, state) => const SignUpPage()),
      GoRoute(path: home, builder: (context, state) => const CoffeeShopPage()),
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
        path: orderTracking,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['id']!;
          return OrderTrackingPage(orderId: orderId);
        },
      ),
      GoRoute(path: profile, builder: (context, state) => const ProfilePage()),
    ],
  );
}

// Helper to trigger GoRouter refresh on auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
