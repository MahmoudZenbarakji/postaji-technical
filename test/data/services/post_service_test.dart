import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_explorer/core/network/api_exception.dart';
import 'package:posts_explorer/data/services/post_service.dart';

void main() {
  group('DioPostService', () {
    test('returns typed posts for a successful response', () async {
      final service = DioPostService(
        _dioReturning(
          statusCode: 200,
          data: [
            {'userId': 1, 'id': 2, 'title': 'Title', 'body': 'Body'},
          ],
        ),
      );

      final posts = await service.getPosts();

      expect(posts.single.id, 2);
    });

    test('passes postId while requesting comments', () async {
      late RequestOptions capturedRequest;
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedRequest = options;
              handler.resolve(
                Response<List<dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: [
                    {
                      'postId': 7,
                      'id': 1,
                      'name': 'Name',
                      'email': 'name@example.com',
                      'body': 'Body',
                    },
                  ],
                ),
              );
            },
          ),
        );
      final service = DioPostService(dio);

      final comments = await service.getComments(7);

      expect(capturedRequest.queryParameters, {'postId': 7});
      expect(comments.single.postId, 7);
    });

    test('maps timeouts to RequestTimeoutException', () async {
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.receiveTimeout,
                ),
              );
            },
          ),
        );

      expect(
        DioPostService(dio).getPosts,
        throwsA(isA<RequestTimeoutException>()),
      );
    });

    test('maps non-success status codes to HttpStatusException', () async {
      final service = DioPostService(
        _dioReturning(statusCode: 404, data: const []),
      );

      expect(
        service.getPosts,
        throwsA(
          isA<HttpStatusException>().having(
            (exception) => exception.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });

    test('maps malformed responses to UnexpectedApiException', () async {
      final service = DioPostService(
        _dioReturning(statusCode: 200, data: const [<String, dynamic>{}]),
      );

      expect(service.getPosts, throwsA(isA<UnexpectedApiException>()));
    });
  });
}

Dio _dioReturning({required int statusCode, required List<dynamic> data}) {
  return Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response<List<dynamic>>(
              requestOptions: options,
              statusCode: statusCode,
              data: data,
            ),
          );
        },
      ),
    );
}
