import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ÉCOUTE : On récupère l'utilisateur (UserEntity? ou null)
    final user = ref.watch(authProvider);

    // CORRECTION : L'utilisateur est authentifié s'il n'est pas null
    final bool isAuthenticated = user != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.navCart,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Contenu du panier (toujours présent en arrière-plan)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart_outlined,
                    size: 72, color: Colors.grey),
                const SizedBox(height: 16),
                Text(AppStrings.emptyCart,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          // 2. Overlay de blocage (Flou) - S'affiche si NON authentifié
          if (!isAuthenticated)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    child: _buildAuthPrompt(context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_person_rounded,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              "Accès Limité",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Veuillez vous connecter pour gérer votre panier et finaliser vos achats.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => context.push('/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
