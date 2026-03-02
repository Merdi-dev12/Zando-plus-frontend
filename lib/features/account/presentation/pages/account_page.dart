import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final bool isAuthenticated = user != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Mon Profil",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => ref.read(authProvider.notifier).logout(),
            )
        ],
      ),
      body: Stack(
        children: [
          // 1. Vue du profil (derrière le flou si non connecté)
          isAuthenticated ? _buildUserView(user) : _buildGuestPlaceholder(),

          // 2. Overlay de flou si non connecté
          if (!isAuthenticated)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    child: _buildAuthPrompt(context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserView(user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header Profil
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: NetworkImage(user.avatar ?? ""),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(user.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user.role.toUpperCase(),
              style: const TextStyle(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 30),

          // Cartes d'informations
          _buildInfoTile(Icons.email_outlined, "Email", user.email),
          _buildInfoTile(Icons.location_on_outlined, "Adresse",
              user.address ?? "Non renseignée"),

          const SizedBox(height: 20),
          const Divider(),
          _buildMenuTile(Icons.shopping_bag_outlined, "Mes Commandes"),
          _buildMenuTile(Icons.favorite_border, "Ma Liste de souhaits"),
          _buildMenuTile(Icons.settings_outlined, "Paramètres"),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _buildGuestPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 150, color: Colors.grey.shade200),
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
            const Icon(Icons.account_circle_outlined,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            const Text("Espace Personnel",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Connectez-vous pour voir vos informations, vos commandes et gérer votre profil.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => context.push('/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Se connecter",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
