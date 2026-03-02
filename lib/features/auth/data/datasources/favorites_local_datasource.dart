import '../../../../features/home/domain/entities/product.dart';

abstract class FavoritesLocalDataSource {
  Future<List<Product>> getSavedFavorites();
  Future<void> saveFavorite(Product product);
  Future<void> deleteFavorite(int productId);
}

// Implémentation simplifiée (Simulation)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final List<Product> _cache = []; // À remplacer par une vraie DB plus tard

  @override
  Future<List<Product>> getSavedFavorites() async => _cache;

  @override
  Future<void> saveFavorite(Product product) async => _cache.add(product);

  @override
  Future<void> deleteFavorite(int productId) async {
    _cache.removeWhere((p) => p.id == productId);
  }
}
