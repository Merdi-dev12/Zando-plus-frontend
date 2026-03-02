import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class AllProductsPage extends ConsumerStatefulWidget {
  const AllProductsPage({super.key});

  @override
  ConsumerState<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends ConsumerState<AllProductsPage> {
  String selectedSort = "Du moins cher au plus cher";

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      // 1. L'AppBar reste simple comme sur le design
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text("Produits",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 2. Barre de recherche et icônes (exactement comme le cadre bleu de ton image)
          _buildTopSearchArea(context),

          // 3. Barre de Filtres (Bouton Filtrer + Chips dynamiques)
          _buildFilterScrollArea(),

          const SizedBox(height: 8),

          // 4. Grille de Produits
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Erreur: $err")),
              data: (products) => GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(
                  product: products[index],
                  onTap: () =>
                      context.push('/product-details', extra: products[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION RECHERCHE ---
  Widget _buildTopSearchArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Champ de recherche
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Bouton Favoris (Détaché de la barre de recherche)
          _iconActionButton(Icons.favorite_border,
              onTap: () => context.push('/favorites')),
          const SizedBox(width: 10),
          // Bouton Panier avec Badge
          _iconActionButton(Icons.shopping_cart_outlined, hasBadge: true),
        ],
      ),
    );
  }

  // --- SECTION FILTRES ---
  Widget _buildFilterScrollArea() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Bouton FILTRER (Mène à la future page)
          _actionButton(
            label: "Filtrer",
            onTap: () {
              context.push('/filter-page');
            },
          ),
          const SizedBox(width: 8),
          // Menu TRIER
          _sortMenu(),
          const SizedBox(width: 12),
          // CHIPS DYNAMIQUES (Représentent les filtres appliqués)
          _activeFilterChip("Lait"),
          const SizedBox(width: 8),
          _activeFilterChip("500 Fc - 1500 Fc"),
        ],
      ),
    );
  }

  // --- WIDGETS DE SOUTIEN ---

  Widget _iconActionButton(IconData icon,
      {bool hasBadge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 22),
            if (hasBadge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Center(
                    child: Text("2",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }

  Widget _sortMenu() {
    return PopupMenuButton<String>(
      onSelected: (val) => setState(() => selectedSort = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Row(
          children: [
            Text("Trier",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: "A-Z", child: Text("De A-Z")),
        const PopupMenuItem(value: "Price", child: Text("Prix croissant")),
      ],
    );
  }

  Widget _activeFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          const Icon(Icons.close_rounded, size: 14, color: Colors.red),
        ],
      ),
    );
  }
}
