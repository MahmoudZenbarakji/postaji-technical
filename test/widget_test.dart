import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:posts_explorer/core/controllers/favorites_controller.dart';
import 'package:posts_explorer/core/network/api_exception.dart';
import 'package:posts_explorer/core/routes/app_routes.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';
import 'package:posts_explorer/data/repositories/post_repository.dart';
import 'package:posts_explorer/modules/post_details/controllers/post_details_controller.dart';
import 'package:posts_explorer/modules/post_details/views/post_details_screen.dart';
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

  setUp(() => Get.put(FavoritesController()));
  tearDown(Get.reset);

  testWidgets('renders posts and navigates when a card is tapped', (
    tester,
  ) async {
    final repository = _FakePostRepository(() async => posts);
    Get.put(PostsController(repository));

    await tester.pumpWidget(
      GetMaterialApp(
        home: const PostsScreen(),
        getPages: [
          GetPage<void>(
            name: AppRoutes.postDetails,
            page: PostDetailsScreen.new,
            binding: BindingsBuilder(() {
              Get.lazyPut(
                () => PostDetailsController(repository, Get.arguments as Post),
              );
            }),
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

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.text('Flutter patterns'));
    await tester.pumpAndSettle();
    expect(find.text('Post details'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    Get.back<void>();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
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
