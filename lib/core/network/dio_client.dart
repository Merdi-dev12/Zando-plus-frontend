import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_strings.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppStrings.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ── Intercepteurs ──────────────────────────────────
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ici plus tard : ajouter le Bearer token auth
        // final token = ref.read(authTokenProvider);
        // if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException error, handler) {
        handler.next(error);
      },
    ),
  );

  // Log uniquement en debug
  assert(() {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );
    return true;
  }());

  return dio;
});