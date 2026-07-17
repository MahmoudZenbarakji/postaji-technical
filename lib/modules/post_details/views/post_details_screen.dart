import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/responsive_breakpoints.dart';
import '../../../widgets/app_error_view.dart';
import '../../../widgets/empty_state_view.dart';
import '../controllers/post_details_controller.dart';
import '../widgets/comment_card.dart';

final class PostDetailsScreen extends GetView<PostDetailsController> {
  const PostDetailsScreen({super.key});

  static const double _maxContentWidth = 840;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post details')),
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
                child: Obx(
                  () => ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      24,
                    ),
                    children: [
                      Text(
                        controller.post.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.post.body,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ..._buildComments(),
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

  List<Widget> _buildComments() {
    if (controller.loading.value && controller.comments.isEmpty) {
      return const [
        SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ];
    }

    if (controller.hasError && controller.comments.isEmpty) {
      return [
        SizedBox(
          height: 280,
          child: AppErrorView(
            message: controller.error.value!,
            onRetry: controller.retry,
          ),
        ),
      ];
    }

    if (controller.isEmpty) {
      return const [
        SizedBox(
          height: 240,
          child: EmptyStateView(
            icon: Icons.forum_outlined,
            title: 'No comments yet',
            message: 'Be the first to join the conversation.',
          ),
        ),
      ];
    }

    return controller.comments
        .map(
          (comment) => CommentCard(key: ValueKey(comment.id), comment: comment),
        )
        .toList(growable: false);
  }
}
