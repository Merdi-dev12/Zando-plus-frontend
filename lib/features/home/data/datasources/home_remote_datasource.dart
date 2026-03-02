import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';


abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<CategoryModel>> getCategories();
}


class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  const HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(AppStrings.productsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Erreur lors de la récupération des produits.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.message ?? 'Erreur réseau inconnue.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(AppStrings.categoriesEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Erreur lors de la récupération des catégories.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.message ?? 'Erreur réseau inconnue.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}


final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(ref.watch(dioProvider));
});