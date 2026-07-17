import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_explorer/core/network/api_exception.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';
import 'package:posts_explorer/data/repositories/post_repository.dart';
import 'package:posts_explorer/modules/post_details/controllers/post_details_controller.dart';

void main() {
  const post = Post(userId: 1, id: 7, title: 'Title', body: 'Body');
  const comments = [
    Comment(
      postId: 7,
      id: 1,
      name: 'Name',
      email: 'name@example.com',
      body: 'Comment body',
    ),
  ];

  test('loads comments for the selected post', () async {
    final result = Completer<List<Comment>>();
    final repository = _FakePostRepository(getComments: (_) => result.future);
    final controller = PostDetailsController(repository, post);

    final request = controller.fetchComments();

    expect(controller.loading.value, isTrue);
    result.complete(comments);
    await request;

    expect(repository.requestedPostId, post.id);
    expect(controller.loading.value, isFalse);
    expect(controller.comments, comments);
    expect(controller.isEmpty, isFalse);
  });

  test('exposes errors and retries loading comments', () async {
    var shouldFail = true;
    final controller = PostDetailsController(
      _FakePostRepository(
        getComments: (_) async {
          if (shouldFail) {
            throw const NetworkException('No connection.');
          }
          return comments;
        },
      ),
      post,
    );

    await controller.fetchComments();
    expect(controller.error.value, 'No connection.');
    expect(controller.hasError, isTrue);

    shouldFail = false;
    await controller.retry();
    expect(controller.error.value, isNull);
    expect(controller.comments, comments);
  });
}

final class _FakePostRepository implements PostRepository {
  _FakePostRepository({
    required Future<List<Comment>> Function(int postId) getComments,
  }) : _getComments = getComments;

  final Future<List<Comment>> Function(int postId) _getComments;
  int? requestedPostId;

  @override
  Future<List<Post>> getPosts() async => const [];

  @override
  Future<List<Comment>> getComments(int postId) {
    requestedPostId = postId;
    return _getComments(postId);
  }
}
