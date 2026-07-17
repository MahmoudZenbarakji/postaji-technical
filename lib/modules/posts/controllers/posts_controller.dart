import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/post.dart';
import '../../../data/repositories/post_repository.dart';

final class PostsController extends GetxController {
  PostsController(this._repository);

  final PostRepository _repository;

  final RxBool loading = false.obs;
  final RxnString error = RxnString();
  final RxList<Post> posts = <Post>[].obs;
  final RxList<Post> filteredPosts = <Post>[].obs;
  final RxString searchText = ''.obs;
  final RxSet<int> favoriteIds = <int>{}.obs;

  bool get isEmpty =>
      !loading.value && error.value == null && filteredPosts.isEmpty;

  bool get hasError => error.value != null;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (loading.value) return;

    loading.value = true;
    error.value = null;

    try {
      final fetchedPosts = await _repository.getPosts();
      posts.assignAll(fetchedPosts);
      _applySearch();
    } on ApiException catch (exception) {
      error.value = exception.message;
    } catch (_) {
      error.value = const UnexpectedApiException().message;
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshPosts() => fetchPosts();

  Future<void> retry() => fetchPosts();

  void search(String query) {
    searchText.value = query;
    _applySearch();
  }

  void toggleFavorite(int id) {
    if (!favoriteIds.remove(id)) {
      favoriteIds.add(id);
    }
  }

  bool isFavorite(int id) => favoriteIds.contains(id);

  void _applySearch() {
    final query = searchText.value.trim().toLowerCase();

    if (query.isEmpty) {
      filteredPosts.assignAll(posts);
      return;
    }

    filteredPosts.assignAll(
      posts.where(
        (post) =>
            post.title.toLowerCase().contains(query) ||
            post.body.toLowerCase().contains(query),
      ),
    );
  }
}
