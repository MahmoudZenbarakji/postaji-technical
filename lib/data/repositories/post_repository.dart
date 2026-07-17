import '../models/post.dart';
import '../services/post_service.dart';

abstract interface class PostRepository {
  Future<List<Post>> getPosts();

  Future<Post> getPost(int id);
}

final class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl(this._service);

  final PostService _service;

  @override
  Future<List<Post>> getPosts() => _service.getPosts();

  @override
  Future<Post> getPost(int id) => _service.getPost(id);
}
