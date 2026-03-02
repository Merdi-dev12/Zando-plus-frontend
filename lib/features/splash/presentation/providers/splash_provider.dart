import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SplashStatus { loading, done }

class SplashNotifier extends StateNotifier<SplashStatus> {
  SplashNotifier() : super(SplashStatus.loading);

  Future<void> init({required VoidCallback onComplete}) async {
    try {
      // 2s : animations finies + légère marge
      await Future.delayed(const Duration(milliseconds: 2200));
      if (mounted) {
        state = SplashStatus.done;
        onComplete();
      }
    } catch (_) {
      if (mounted) {
        state = SplashStatus.done;
        onComplete();
      }
    }
  }
}

final splashProvider =
    StateNotifierProvider.autoDispose<SplashNotifier, SplashStatus>(
  (_) => SplashNotifier(),
);