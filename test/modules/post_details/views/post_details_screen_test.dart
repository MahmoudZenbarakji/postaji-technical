import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';
import 'package:posts_explorer/data/repositories/post_repository.dart';
import 'package:posts_explorer/modules/post_details/controllers/post_details_controller.dart';
import 'package:posts_explorer/modules/post_details/views/post_details_screen.dart';

void main() {
  const post = Post(
    userId: 1,
    id: 7,
    title: 'Selected post',
    body: 'The complete post body.',
  );
  const comment = Comment(
    postId: 7,
    id: 1,
    name: 'Jane Doe',
    email: 'jane@example.com',
    body: 'A thoughtful comment.',
  );

  tearDown(Get.reset);

  testWidgets('displays the selected post and its comments', (tester) async {
    Get.put(
      PostDetailsController(
        _FakePostRepository(comments: const [comment]),
        post,
      ),
    );

    await tester.pumpWidget(const GetMaterialApp(home: PostDetailsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Selected post'), findsOneWidget);
    expect(find.text('The complete post body.'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.text('jane@example.com'), findsOneWidget);
    expect(find.text('A thoughtful comment.'), findsOneWidget);
  });
}

final class _FakePostRepository implements PostRepository {
  const _FakePostRepository({required this.comments});

  final List<Comment> comments;

  @override
  Future<List<Post>> getPosts() async => const [];

  @override
  Future<List<Comment>> getComments(int postId) async => comments;
}
