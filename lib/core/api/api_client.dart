import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.252.252.32:8000/api', 
      headers: {'Accept': 'application/json'},
    ),
  );
}
