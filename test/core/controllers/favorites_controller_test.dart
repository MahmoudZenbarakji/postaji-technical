import 'package:flutter_test/flutter_test.dart';
import 'package:posts_explorer/core/controllers/favorites_controller.dart';

void main() {
  test('toggles favorite post IDs in memory', () {
    final controller = FavoritesController();

    controller.toggleFavorite(1);
    expect(controller.isFavorite(1), isTrue);
    expect(controller.favoriteIds, {1});

    controller.toggleFavorite(1);
    expect(controller.isFavorite(1), isFalse);
    expect(controller.favoriteIds, isEmpty);
  });
}
