import 'package:get/get.dart';

import '../../modules/post_details/bindings/post_details_binding.dart';
import '../../modules/post_details/views/post_details_page.dart';
import '../../modules/posts/bindings/posts_binding.dart';
import '../../modules/posts/views/posts_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage<void>(
      name: AppRoutes.posts,
      page: PostsPage.new,
      binding: PostsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.postDetails,
      page: PostDetailsPage.new,
      binding: PostDetailsBinding(),
    ),
  ];
}
