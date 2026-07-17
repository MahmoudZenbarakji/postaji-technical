import 'package:get/get.dart';

import '../../../data/repositories/post_repository.dart';
import '../controllers/post_details_controller.dart';

final class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostDetailsController>(
      () => PostDetailsController(Get.find<PostRepository>()),
    );
  }
}
