import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories_usecase.dart';

final categoriesProvider =
    FutureProvider.autoDispose<List<Category>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return GetCategoriesUseCase(repository).call();
});