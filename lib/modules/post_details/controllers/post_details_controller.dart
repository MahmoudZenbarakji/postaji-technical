import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/comment.dart';
import '../../../data/models/post.dart';
import '../../../data/repositories/post_repository.dart';

final class PostDetailsController extends GetxController {
  PostDetailsController(this._repository, this.post);

  final PostRepository _repository;
  final Post post;

  final RxBool loading = false.obs;
  final RxnString error = RxnString();
  final RxList<Comment> comments = <Comment>[].obs;

  bool get isEmpty => !loading.value && error.value == null && comments.isEmpty;

  bool get hasError => error.value != null;

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    if (loading.value) return;

    loading.value = true;
    error.value = null;

    try {
      comments.assignAll(await _repository.getComments(post.id));
    } on ApiException catch (exception) {
      error.value = exception.message;
    } catch (_) {
      error.value = const UnexpectedApiException().message;
    } finally {
      loading.value = false;
    }
  }

  Future<void> retry() => fetchComments();
}
