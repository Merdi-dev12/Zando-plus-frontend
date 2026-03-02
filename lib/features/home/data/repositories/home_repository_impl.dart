import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      return await _remoteDataSource.getProducts();
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const ServerFailure();
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await _remoteDataSource.getCategories();
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const ServerFailure();
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
});