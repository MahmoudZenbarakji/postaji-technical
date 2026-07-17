import 'package:get/get.dart';

import '../../../data/repositories/post_repository.dart';
import '../controllers/posts_controller.dart';

final class PostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostsController>(
      () => PostsController(Get.find<PostRepository>()),
    );
  }
}
