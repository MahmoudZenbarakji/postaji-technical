import 'package:get/get.dart';

import '../../../data/repositories/post_repository.dart';

final class PostDetailsController extends GetxController {
  PostDetailsController(this.repository);

  final PostRepository repository;
}
