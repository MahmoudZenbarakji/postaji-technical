import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/favorites_controller.dart';

final class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({required this.postId, super.key});

  final int postId;

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();

    return Obx(() {
      final isFavorite = favorites.isFavorite(postId);

      return IconButton(
        onPressed: () {
          favorites.toggleFavorite(postId);
          final isNowFavorite = favorites.isFavorite(postId);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  isNowFavorite
                      ? 'Added to favorites'
                      : 'Removed from favorites',
                ),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => favorites.toggleFavorite(postId),
                ),
              ),
            );
        },
        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            color: isFavorite ? Theme.of(context).colorScheme.error : null,
          ),
        ),
      );
    });
  }
}
