import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Carousel ──────────────────────────────────
        FlutterCarousel(
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.fastOutSlowIn,
            showIndicator: false,
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          items: AppStrings.carouselImages.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.productImageBg,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.productImageBg,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textHint,
                    size: 36,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        // ── Dot indicators custom ──────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: AppStrings.carouselImages.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}