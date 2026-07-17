import 'package:get/get.dart';

final class FavoritesController extends GetxController {
  final RxSet<int> favoriteIds = <int>{}.obs;

  void toggleFavorite(int postId) {
    if (!favoriteIds.remove(postId)) {
      favoriteIds.add(postId);
    }
  }

  bool isFavorite(int postId) => favoriteIds.contains(postId);
}
