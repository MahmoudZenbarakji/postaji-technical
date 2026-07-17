import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_breakpoints.dart';
import '../../../widgets/app_error_view.dart';
import '../../../widgets/app_loading_view.dart';
import '../../../widgets/empty_state_view.dart';
import '../controllers/posts_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/post_search_field.dart';

final class PostsScreen extends GetView<PostsController> {
  const PostsScreen({super.key});

  static const double _maxContentWidth = 840;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts Explorer')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                ResponsiveBreakpoints.isMobile(constraints.maxWidth)
                ? 16.0
                : 24.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    0,
                  ),
                  child: Column(
                    children: [
                      PostSearchField(onChanged: controller.search),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _buildContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.loading.value && controller.posts.isEmpty) {
      return const AppLoadingView(
        key: ValueKey('loading'),
        message: 'Finding great posts…',
      );
    }

    if (controller.hasError && controller.posts.isEmpty) {
      return AppErrorView(
        key: const ValueKey('error'),
        message: controller.error.value!,
        onRetry: controller.retry,
      );
    }

    if (controller.filteredPosts.isEmpty) {
      final isSearching = controller.searchText.value.trim().isNotEmpty;

      return _RefreshableState(
        key: const ValueKey('empty'),
        onRefresh: controller.refreshPosts,
        child: EmptyStateView(
          icon: isSearching ? Icons.search_off : Icons.inbox_outlined,
          title: isSearching ? 'No matching posts' : 'No posts yet',
          message: isSearching
              ? 'Try a different search term.'
              : 'Pull down to check for new posts.',
        ),
      );
    }

    return RefreshIndicator(
      key: const ValueKey('posts'),
      onRefresh: controller.refreshPosts,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: controller.filteredPosts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final post = controller.filteredPosts[index];

          return PostCard(
            key: ValueKey(post.id),
            post: post,
            onTap: () => Get.toNamed(
              AppRoutes.postDetailsPath(post.id),
              arguments: post,
            ),
          );
        },
      ),
    );
  }
}

final class _RefreshableState extends StatelessWidget {
  const _RefreshableState({
    required this.onRefresh,
    required this.child,
    super.key,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              width: double.infinity,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
