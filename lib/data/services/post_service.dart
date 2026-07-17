import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/post.dart';

abstract interface class PostService {
  Future<List<Post>> getPosts();

  Future<Post> getPost(int id);
}

final class DioPostService implements PostService {
  const DioPostService(this._dio);

  final Dio _dio;

  @override
  Future<List<Post>> getPosts() async {
    final response = await _dio.get<List<dynamic>>(ApiConstants.posts);
    final data = response.data ?? const <dynamic>[];

    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<Post> getPost(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.posts}/$id',
    );
    final data = response.data;

    if (data == null) {
      throw StateError('The post response was empty.');
    }

    return Post.fromJson(data);
  }
}
