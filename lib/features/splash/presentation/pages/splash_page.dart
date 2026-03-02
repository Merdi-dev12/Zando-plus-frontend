import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../providers/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;

  late final AnimationController _textCtrl;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  late final AnimationController _progressCtrl;

  late final AnimationController _haloCtrl;
  late final Animation<double> _haloScale;
  late final Animation<double> _haloOpacity;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _logoScale = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoCtrl,
          curve: const Interval(0.0, 0.85, curve: Curves.elasticOut)),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoCtrl,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _logoCtrl,
          curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic)),
    );

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _textFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _textSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );

    _haloCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _haloScale = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _haloCtrl, curve: Curves.easeInOut));
    _haloOpacity = Tween<double>(begin: 0.12, end: 0.22)
        .animate(CurvedAnimation(parent: _haloCtrl, curve: Curves.easeInOut));

    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    _runSequence();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Supprime le splash natif pour laisser place à l'animation Flutter
      FlutterNativeSplash.remove();

      ref.read(splashProvider.notifier).init(
        onComplete: () {
          if (mounted) context.go(AppRoutes.home);
        },
      );
    });
  }

  Future<void> _runSequence() async {
    _progressCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) _textCtrl.forward();
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _haloCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogoSection(),
                const SizedBox(height: 32),
                _buildTextSection(),
              ],
            ),
          ),
          _buildProgressBar(bottom),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.06)),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0A1E3D).withOpacity(0.04)),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _haloCtrl,
            builder: (_, __) => Transform.scale(
              scale: _haloScale.value,
              child: Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(_haloOpacity.value),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _logoCtrl,
            builder: (_, child) => FadeTransition(
              opacity: _logoFade,
              child: SlideTransition(
                position: _logoSlide,
                child: Transform.scale(scale: _logoScale.value, child: child),
              ),
            ),
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF0A1E3D).withOpacity(0.25),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                      spreadRadius: -4),
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 48,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset('assets/images/logo.PNG',
                    width: 128, height: 128, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return AnimatedBuilder(
      animation: _textCtrl,
      builder: (_, child) => FadeTransition(
        opacity: _textFade,
        child: SlideTransition(position: _textSlide, child: child),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Zando',
                  style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0A1E3D),
                      letterSpacing: -0.5),
                ),
                TextSpan(
                  text: ' Plus',
                  style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double bottom) {
    return Positioned(
      bottom: bottom + 48,
      left: 40,
      right: 40,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 3,
                color: AppColors.primary.withOpacity(0.1),
                child: AnimatedBuilder(
                  animation: _progressCtrl,
                  builder: (_, __) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressCtrl.value,
                    child: Container(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Chargement en cours...',
                style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}
