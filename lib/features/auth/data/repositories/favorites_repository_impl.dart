import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';
import '../../../../features/home/domain/entities/product.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getFavorites() => localDataSource.getSavedFavorites();

  @override
  Future<void> addFavorite(Product product) =>
      localDataSource.saveFavorite(product);

  @override
  Future<void> removeFavorite(int productId) =>
      localDataSource.deleteFavorite(productId);

  @override
  Future<bool> isFavorite(int productId) async {
    final list = await localDataSource.getSavedFavorites();
    return list.any((p) => p.id == productId);
  }
}
