import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

final class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Accept': 'application/json'},
    ),
  );
}
