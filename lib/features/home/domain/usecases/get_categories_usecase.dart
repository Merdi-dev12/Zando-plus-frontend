import '../entities/category.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<List<Category>> call() => _repository.getCategories();
}