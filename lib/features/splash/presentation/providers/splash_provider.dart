import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SplashStatus { loading, done }

class SplashNotifier extends StateNotifier<SplashStatus> {
  SplashNotifier() : super(SplashStatus.loading);

  Future<void> init({required VoidCallback onComplete}) async {
    // Debug pour voir si la fonction est bien appelée
    print("Log: Splash d'initialisation démarré...");

    try {
      // 2.2s pour laisser l'animation se terminer
      await Future.delayed(const Duration(milliseconds: 2200));

      if (mounted) {
        state = SplashStatus.done;
        print("Log: Splash terminé, appel de onComplete");
        onComplete();
      }
    } catch (e) {
      print("Log: Erreur Splash: $e");
      if (mounted) {
        state = SplashStatus.done;
        onComplete();
      }
    }
  }
}

// On retire .autoDispose pour éviter une fermeture prématurée pendant la navigation
final splashProvider = StateNotifierProvider<SplashNotifier, SplashStatus>(
  (ref) => SplashNotifier(),
);
