import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return GetProductsUseCase(repository).call();
});