import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Imports Pages
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/all-products.dart';
import '../../features/home/presentation/pages/filter_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
// Imports Auth (Nouvel ajout)
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';

import '../shell/bottom_nav_bar.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/splash';
  static const String home = '/';
  static const String cart = '/cart';
  static const String explore = '/explore';
  static const String account = '/account';
  static const String favorites = '/favorites';
  static const String allProducts = '/all-products';
  static const String filterPage = '/filter-page';

  // Routes Auth
  static const String welcome = '/welcome';
  static const String signIn =
      '/auth'; // Correspond à ton context.push('/auth')
  static const String signUp = '/auth/signup';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // ─── ROUTE SPLASH ───
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashPage(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),

      // ─── ROUTES AUTHENTIFICATION ───
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
        routes: [
          GoRoute(
            path: 'signup', // Chemin final : /auth/signup
            builder: (context, state) => const SignUpPage(),
          ),
        ],
      ),

      // ─── NAVIGATION AVEC SHELL (BOTTOM BAR) ───
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavBar(navigationShell: navigationShell),
        branches: [
          // Branche HOME
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
              routes: [
                GoRoute(
                  path: 'favorites', // Accès via /favorites
                  builder: (context, state) => const FavoritesPage(),
                ),
                GoRoute(
                  path: 'all-products', // Accès via /all-products
                  builder: (context, state) => const AllProductsPage(),
                  routes: [
                    // Filtre placé en sous-route pour une navigation logique
                    GoRoute(
                      path: 'filter', // Accès via /all-products/filter
                      builder: (context, state) => const FilterPage(),
                    ),
                  ],
                ),
                // Route directe pour le filtre si nécessaire
                GoRoute(
                  path: 'filter-page',
                  builder: (context, state) => const FilterPage(),
                ),
              ],
            )
          ]),
          // Branche PANIER
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.cart,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CartPage()))
          ]),
          // Branche EXPLORE
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ExplorePage()))
          ]),
          // Branche COMPTE
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.account,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AccountPage()))
          ]),
        ],
      ),
    ],
  );
});
