import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../shell/bottom_nav_bar.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash  = '/splash';
  static const String home    = '/';
  static const String cart    = '/cart';
  static const String explore = '/explore';
  static const String account = '/account';
}


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [

      // ── Splash (hors shell — pas de bottom nav) ──
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashPage(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),

      // ── Shell principal avec bottom nav ──────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),

          // 1 — Panier
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CartPage(),
                ),
              ),
            ],
          ),

          // 2 — Explorer
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ExplorePage(),
                ),
              ),
            ],
          ),

          // 3 — Compte
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AccountPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});