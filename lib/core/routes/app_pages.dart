import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../modules/post_details/bindings/post_details_binding.dart';
import '../../modules/post_details/views/post_details_screen.dart';
import '../../modules/posts/bindings/posts_binding.dart';
import '../../modules/posts/views/posts_screen.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage<void>(
      name: AppRoutes.posts,
      page: PostsScreen.new,
      binding: PostsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage<void>(
      name: AppRoutes.postDetails,
      page: PostDetailsScreen.new,
      binding: PostDetailsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    ),
  ];
}
