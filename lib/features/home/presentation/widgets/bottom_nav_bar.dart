import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// ─────────────────────────────────────────────
// MODÈLE D'UN ITEM NAV
// ─────────────────────────────────────────────
class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

// ─────────────────────────────────────────────
// BOTTOM NAV BAR PRINCIPALE
// ─────────────────────────────────────────────
class BottomNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {

  // ── Items de navigation ───────────────────────────
  static const List<_NavItem> _items = [
    _NavItem(
      activeIcon:   Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: AppStrings.navHome,
    ),
    _NavItem(
      activeIcon:   Icons.shopping_cart_rounded,
      inactiveIcon: Icons.shopping_cart_outlined,
      label: AppStrings.navCart,
    ),
    _NavItem(
      activeIcon:   Icons.grid_view_rounded,
      inactiveIcon: Icons.grid_view_outlined,
      label: AppStrings.navExplore,
    ),
    _NavItem(
      activeIcon:   Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: AppStrings.navAccount,
    ),
  ];

  // ── Animation controllers (un par item) ──────────
  late final List<AnimationController> _controllers;

  // Scale : shrink → overshoot → settle  (style Telegram)
  late final List<Animation<double>> _scaleAnims;

  // Bounce vertical : monte légèrement puis retombe
  late final List<Animation<double>> _bounceAnims;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _items.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 420),
      ),
    );

    _scaleAnims = _controllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.72)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.72, end: 1.15)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 45,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.15, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
      ]).animate(c);
    }).toList();

    _bounceAnims = _controllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -7.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -7.0, end: 0.0)
              .chain(CurveTween(curve: Curves.bounceOut)),
          weight: 50,
        ),
      ]).animate(c);
    }).toList();

    // Lance l'animation de l'onglet initial
    _controllers[widget.navigationShell.currentIndex].forward();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Tap ───────────────────────────────────────────
  void _onTap(int index) {
    if (index == widget.navigationShell.currentIndex) return;

    // Lance l'animation sur le NOUVEL onglet sélectionné
    _controllers[index].forward(from: 0);

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // ── Build ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true, // contenu passe sous la nav bar (glass)
      body: widget.navigationShell,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                // verre blanc semi-transparent
                color: Colors.white.withOpacity(0.82),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.55),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 88, 88, 88).withOpacity(0.10),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _items.length,
                  (index) {
                    final isActive =
                        widget.navigationShell.currentIndex == index;
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedBuilder(
                        animation: _controllers[index],
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _bounceAnims[index].value),
                          child: Transform.scale(
                            scale: _scaleAnims[index].value,
                            child: child,
                          ),
                        ),
                        child: _NavItemWidget(
                          item: _items[index],
                          isActive: isActive,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ITEM INDIVIDUEL
// ─────────────────────────────────────────────
class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isActive;

  const _NavItemWidget({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Icône dans son cercle ──────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.navActiveCircle
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? item.activeIcon : item.inactiveIcon,
              size: 20,
              color: isActive ? Colors.white : AppColors.navInactiveIcon,
            ),
          ),

          const SizedBox(height: 2),

          // ── Label ─────────────────────────────
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: isActive
                ? AppTextStyles.navLabelActive
                : AppTextStyles.navLabelInactive,
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}