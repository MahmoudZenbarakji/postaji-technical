import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/network/app_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const PostsExplorerApp());

class PostsExplorerApp extends StatelessWidget {
  const PostsExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Posts Explorer',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.posts,
      getPages: AppPages.routes,
      theme: AppTheme.light,
    );
  }
}
