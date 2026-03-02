import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/domain/entities/product.dart';
import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';

// Provider pour le repository
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl());
});

// StateNotifier pour gérer la liste des favoris
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final FavoritesRepository repository;

  FavoritesNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final list = await repository.getFavorites();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final isFav = await repository.isFavorite(product.id ?? 0);
    if (isFav) {
      await repository.removeFavorite(product.id ?? 0);
    } else {
      await repository.addFavorite(product);
    }
    loadFavorites(); // Rafraîchit la liste
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Product>>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});
