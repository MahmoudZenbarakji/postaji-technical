import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:posts_explorer/core/network/api_exception.dart';
import 'package:posts_explorer/core/routes/app_routes.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';
import 'package:posts_explorer/data/repositories/post_repository.dart';
import 'package:posts_explorer/modules/posts/controllers/posts_controller.dart';
import 'package:posts_explorer/modules/posts/views/posts_screen.dart';

void main() {
  const posts = [
    Post(
      userId: 1,
      id: 1,
      title: 'Flutter patterns',
      body: 'A reusable approach to Flutter application architecture.',
    ),
  ];

  tearDown(Get.reset);

  testWidgets('renders posts and navigates when a card is tapped', (
    tester,
  ) async {
    Get.put(PostsController(_FakePostRepository(() async => posts)));

    await tester.pumpWidget(
      GetMaterialApp(
        home: const PostsScreen(),
        getPages: [
          GetPage<void>(
            name: AppRoutes.postDetails,
            page: () => const SizedBox(key: Key('details-placeholder')),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Posts Explorer'), findsOneWidget);
    expect(find.text('Flutter patterns'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);

    final body = tester.widget<Text>(
      find.text('A reusable approach to Flutter application architecture.'),
    );
    expect(body.maxLines, 2);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.tap(find.text('Flutter patterns'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('details-placeholder')), findsOneWidget);
  });

  testWidgets('shows an error and retries the request', (tester) async {
    var shouldFail = true;
    Get.put(
      PostsController(
        _FakePostRepository(() async {
          if (shouldFail) {
            throw const NetworkException('No connection.');
          }
          return posts;
        }),
      ),
    );

    await tester.pumpWidget(const GetMaterialApp(home: PostsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('No connection.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    shouldFail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Flutter patterns'), findsOneWidget);
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
