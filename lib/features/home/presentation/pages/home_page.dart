import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/categories_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync   = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ─── Search bar ──────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _SearchBar(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ─── Carousel ────────────────────────────────
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(child: BannerCarousel()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ─── Section Catégorie ───────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: AppStrings.categories,
                  onSeeAll: () {},
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // ─── Liste catégories ────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 88,
                child: categoriesAsync.when(
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, __) => const CategoryChipSkeleton(),
                  ),
                  error: (_, __) => _ErrorRetry(
                    onRetry: () => ref.refresh(categoriesProvider),
                  ),
                  data: (categories) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, i) => CategoryChip(
                      category: categories[i],
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ─── Section Produits populaires ─────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: AppStrings.popularProducts,
                  onSeeAll: () {},
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // ─── Grille produits ─────────────────────────
            productsAsync.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.builder(
                  gridDelegate: _gridDelegate(),
                  itemCount: 4,
                  itemBuilder: (_, __) => const ProductCardSkeleton(),
                ),
              ),
              error: (_, __) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ErrorRetry(
                    onRetry: () => ref.refresh(productsProvider),
                  ),
                ),
              ),
              data: (products) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.builder(
                  gridDelegate: _gridDelegate(),
                  itemCount: products.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: products[i],
                    onTap: () {},
                  ),
                ),
              ),
            ),

            // Espace bas pour la bottom nav flottante
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  // Ratio ajusté pour la card avec étoiles + prix + bouton +
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 12,
      childAspectRatio: 0.62,
    );
  }
}

// ─────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Champ de recherche — fond blanc, sans ombre ──
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface, // blanc pur
              borderRadius: BorderRadius.circular(14),
              // PAS d'ombre — fidèle au Figma
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  AppStrings.searchHint,
                  style: AppTextStyles.searchHint,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Icône cœur — nue, sans fond ni cercle ────────
        GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.favorite_border_rounded,
            color: AppColors.textPrimary,
            size: 26,
          ),
        ),

        const SizedBox(width: 14),

        // ── Icône cloche + badge 200 ──────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ),
            Positioned(
              top: -6,
              right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '200',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(AppStrings.seeAll, style: AppTextStyles.seeAll),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ERROR + RETRY
// ─────────────────────────────────────────────
class _ErrorRetry extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorRetry({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.errorNetwork,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                AppStrings.retry,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}