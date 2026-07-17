import '../models/comment.dart';
import '../models/post.dart';
import '../services/post_service.dart';

abstract interface class PostRepository {
  Future<List<Post>> getPosts();

  Future<List<Comment>> getComments(int postId);
}

final class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl(this._service);

  final PostService _service;

  @override
  Future<List<Post>> getPosts() => _service.getPosts();

  @override
  Future<List<Comment>> getComments(int postId) => _service.getComments(postId);
}
