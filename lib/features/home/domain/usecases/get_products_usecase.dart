import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<List<Product>> call() => _repository.getProducts();
}