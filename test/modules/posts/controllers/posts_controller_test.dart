import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_explorer/core/network/api_exception.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';
import 'package:posts_explorer/data/repositories/post_repository.dart';
import 'package:posts_explorer/modules/posts/controllers/posts_controller.dart';

void main() {
  const posts = [
    Post(userId: 1, id: 1, title: 'Flutter patterns', body: 'GetX state'),
    Post(userId: 1, id: 2, title: 'Dart models', body: 'Immutable data'),
  ];

  test('tracks loading and stores fetched posts', () async {
    final result = Completer<List<Post>>();
    final controller = PostsController(
      _FakePostRepository(() => result.future),
    );

    final request = controller.fetchPosts();

    expect(controller.loading.value, isTrue);
    result.complete(posts);
    await request;

    expect(controller.loading.value, isFalse);
    expect(controller.posts, posts);
    expect(controller.filteredPosts, posts);
    expect(controller.isEmpty, isFalse);
  });

  test('filters posts by title and body without case sensitivity', () async {
    final controller = PostsController(_FakePostRepository(() async => posts));
    await controller.fetchPosts();

    controller.search('FLUTTER');
    expect(controller.filteredPosts.map((post) => post.id), [1]);

    controller.search('immutable');
    expect(controller.filteredPosts.map((post) => post.id), [2]);

    controller.search('missing');
    expect(controller.filteredPosts, isEmpty);
    expect(controller.isEmpty, isTrue);

    controller.search('');
    expect(controller.filteredPosts, posts);
  });

  test('exposes errors and supports retry', () async {
    var shouldFail = true;
    final controller = PostsController(
      _FakePostRepository(() async {
        if (shouldFail) {
          throw const NetworkException('No connection.');
        }
        return posts;
      }),
    );

    await controller.fetchPosts();
    expect(controller.error.value, 'No connection.');
    expect(controller.hasError, isTrue);
    expect(controller.loading.value, isFalse);

    shouldFail = false;
    await controller.retry();
    expect(controller.error.value, isNull);
    expect(controller.posts, posts);
  });

  test('refreshes posts through the repository', () async {
    var calls = 0;
    final controller = PostsController(
      _FakePostRepository(() async {
        calls++;
        return posts;
      }),
    );

    await controller.fetchPosts();
    await controller.refreshPosts();

    expect(calls, 2);
  });
}

final class _FakePostRepository implements PostRepository {
  const _FakePostRepository(this._getPosts);

  final Future<List<Post>> Function() _getPosts;

  @override
  Future<List<Post>> getPosts() => _getPosts();

  @override
  Future<List<Comment>> getComments(int postId) async => const [];
}
