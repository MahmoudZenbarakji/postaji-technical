import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:posts_explorer/core/routes/app_routes.dart';
import 'package:posts_explorer/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('starts on the posts route', (tester) async {
    await tester.pumpWidget(const PostsExplorerApp());
    await tester.pump();

    expect(Get.currentRoute, AppRoutes.posts);
  });
}
