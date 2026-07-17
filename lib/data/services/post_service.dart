import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_exception.dart';
import '../models/comment.dart';
import '../models/post.dart';

abstract interface class PostService {
  Future<List<Post>> getPosts();

  Future<List<Comment>> getComments(int postId);
}

final class DioPostService implements PostService {
  const DioPostService(this._dio);

  final Dio _dio;

  @override
  Future<List<Post>> getPosts() =>
      _getList(path: ApiConstants.posts, fromJson: Post.fromJson);

  @override
  Future<List<Comment>> getComments(int postId) => _getList(
    path: ApiConstants.comments,
    queryParameters: {'postId': postId},
    fromJson: Comment.fromJson,
  );

  Future<List<T>> _getList<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(validateStatus: (_) => true),
      );

      _validateStatus(response.statusCode);

      final data = response.data;
      if (data == null) {
        throw const UnexpectedApiException();
      }

      return data
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } on ApiException {
      rethrow;
    } on DioException catch (exception) {
      throw _mapDioException(exception);
    } catch (_) {
      throw const UnexpectedApiException();
    }
  }

  void _validateStatus(int? statusCode) {
    if (statusCode == null) {
      throw const NetworkException('The server returned no status code.');
    }

    if (statusCode < 200 || statusCode >= 300) {
      throw HttpStatusException(
        statusCode: statusCode,
        message: _statusMessage(statusCode),
      );
    }
  }

  ApiException _mapDioException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const RequestTimeoutException(),
      DioExceptionType.badResponse => HttpStatusException(
        statusCode: exception.response?.statusCode ?? 0,
        message: _statusMessage(exception.response?.statusCode),
      ),
      DioExceptionType.cancel => const NetworkException(
        'The request was cancelled.',
      ),
      DioExceptionType.connectionError => const NetworkException(
        'Could not connect to the server.',
      ),
      DioExceptionType.badCertificate => const NetworkException(
        'The server certificate is invalid.',
      ),
      DioExceptionType.unknown => const NetworkException(
        'A network error occurred.',
      ),
    };
  }

  String _statusMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'The request was invalid.',
      401 => 'Authentication is required.',
      403 => 'Access to this resource is forbidden.',
      404 => 'The requested resource was not found.',
      int code when code >= 500 && code < 600 =>
        'The server encountered an error.',
      _ => 'The request failed with status code ${statusCode ?? 'unknown'}.',
    };
  }
}
