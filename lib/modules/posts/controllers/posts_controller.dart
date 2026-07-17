import 'package:get/get.dart';

import '../../../data/repositories/post_repository.dart';

final class PostsController extends GetxController {
  PostsController(this.repository);

  final PostRepository repository;
}
