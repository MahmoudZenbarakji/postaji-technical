import 'package:get/get.dart';

import '../../../data/models/post.dart';
import '../../../data/repositories/post_repository.dart';
import '../controllers/post_details_controller.dart';

final class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final argument = Get.arguments;
    if (argument is! Post) {
      throw ArgumentError(
        'PostDetailsScreen requires a Post navigation argument.',
      );
    }

    Get.lazyPut<PostDetailsController>(
      () => PostDetailsController(Get.find<PostRepository>(), argument),
    );
  }
}
