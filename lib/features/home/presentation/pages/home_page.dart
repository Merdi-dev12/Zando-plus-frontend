import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/products_provider.dart';
import '../providers/categories_provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/product_card.dart';
import '../../../../features/favorites/presentation/pages/favorites_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── Barre de recherche fixe ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _SearchBar(
                onFavoritesTap: () => context.go('/favorites'),
              ),
            ),

            // ─── Zone défilante ───
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(productsProvider);
                  ref.invalidate(categoriesProvider);
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // Carousel
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(child: BannerCarousel()),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Section Catégories
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: AppStrings.categories,
                          onSeeAll: () => context.go('/explore'),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 14)),

                    // Liste catégories dynamique
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: categoriesAsync.when(
                          loading: () => ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemBuilder: (_, __) =>
                                const CategoryChipSkeleton(),
                          ),
                          error: (err, _) => _ErrorRetry(
                            onRetry: () => ref.refresh(categoriesProvider),
                          ),
                          data: (categories) => ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 20),
                            itemBuilder: (_, i) => _CategoryItem(
                              category: categories[i],
                              onTap: () => context.go('/explore'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Section Produits
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: AppStrings.popularProducts,
                          onSeeAll: () => context.go('/all-products'),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 14)),

                    // Grille produits dynamique
                    productsAsync.when(
                      loading: () => SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid.builder(
                          gridDelegate: _gridDelegate(),
                          itemCount: 4,
                          itemBuilder: (_, __) => const ProductCardSkeleton(),
                        ),
                      ),
                      error: (err, _) => SliverToBoxAdapter(
                        child: _ErrorRetry(
                            onRetry: () => ref.refresh(productsProvider)),
                      ),
                      data: (products) => SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid.builder(
                          gridDelegate: _gridDelegate(),
                          itemCount: products.length,
                          itemBuilder: (_, i) {
                            final product = products[i];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                // CLIC RENDU POSSIBLE : Navigation vers les détails
                                context.push('/product-details',
                                    extra: product);
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 12,
      childAspectRatio: 0.65,
    );
  }
}

// ─────────────────────────────────────────────
// COMPOSANTS DE SOUTIEN
// ─────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  const _CategoryItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.teal.shade50, width: 2),
            ),
            child: ClipOval(
              child: category.imageUrl.isNotEmpty
                  ? Image.network(category.imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.category, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(category.name,
              style: AppTextStyles.bodySmall
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onFavoritesTap;
  const _SearchBar({required this.onFavoritesTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              onSubmitted: (value) => context.go('/explore?search=$value'),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textHint, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onFavoritesTap,
          icon: const Icon(Icons.favorite_border_rounded,
              color: AppColors.textPrimary, size: 26),
        ),
        _NotificationBadge(),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textPrimary, size: 26),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10)),
            child: const Text('2',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        TextButton(
          onPressed: onSeeAll,
          child: Text(AppStrings.seeAll, style: AppTextStyles.seeAll),
        ),
      ],
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorRetry({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, color: Colors.grey, size: 40),
          const SizedBox(height: 8),
          const Text("Erreur de chargement",
              style: TextStyle(color: Colors.grey)),
          TextButton(onPressed: onRetry, child: const Text("Réessayer")),
        ],
      ),
    );
  }
}

// ─── SKELETONS ───

class CategoryChipSkeleton extends StatelessWidget {
  const CategoryChipSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.grey[300]),
          const SizedBox(height: 8),
          Container(width: 50, height: 10, color: Colors.grey[300]),
        ],
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ProductCard(
        product: Product(
          id: 0,
          name: "Chargement...",
          categoryId: 0,
          description: "description",
          price: "0",
          imageUrl: "https://placeholder.com",
          quantity: 0,
          rating: 4.5,
          isFavorite: false,
        ),
        onTap: () {},
      ),
    );
  }
}
