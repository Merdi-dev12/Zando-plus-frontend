import '../../../../features/home/domain/entities/product.dart';

abstract class FavoritesRepository {
  Future<List<Product>> getFavorites();
  Future<void> addFavorite(Product product);
  Future<void> removeFavorite(int productId);
  Future<bool> isFavorite(int productId);
}
