import '../entities/category.dart';
import '../entities/product.dart';

abstract class HomeRepository {
  Future<List<Product>> getProducts();
  Future<List<Category>> getCategories();
}