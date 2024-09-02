import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/PostController.dart';
import '../widgets/PostListItem.dart';

class HomeScreen extends StatelessWidget {
  // Put Post Controller
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Scroll List notify
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              // Determine visible post IDs
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _determineVisiblePosts(context);
              });
            }
            return true;
          },
          child: ListView.builder(
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              //Get post data index wise
              final post = postController.posts[index];
              return PostListItem(
                post: post,
                onReadAndNavigate: () =>
                    postController.markAsReadAndNavigate(post),
                onTimerTap: () => postController.startTimer(post),
                key: ValueKey(post.id), // Unique key for each post
              );
            },
          ),
        );
      }),
    );
  }


  // Determine Visible Post when Scrolling
  void _determineVisiblePosts(BuildContext context) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final visibilityInfo = _getVisiblePostIds(renderObject, context);
      postController.setVisiblePostIds(visibilityInfo);
    }
  }

  // Get Visible Post when Scrolling
  Set<int> _getVisiblePostIds(
      RenderBox listRenderBox, BuildContext currentContext) {
    final visiblePostIds = <int>{};
    for (var post in postController.posts) {
      final key = ValueKey(post.id);
      final context = key;
      if (context != null && _isWidgetVisible(currentContext, listRenderBox)) {
        visiblePostIds.add(post.id);
      }
    }
    return visiblePostIds;
  }

  // Widget Visible When Scroll
  bool _isWidgetVisible(BuildContext context, RenderBox listRenderBox) {
    final widgetRenderBox = context.findRenderObject() as RenderBox?;
    if (widgetRenderBox == null || !widgetRenderBox.hasSize) {
      return false;
    }

    final listSize = listRenderBox.size;
    final listPosition = listRenderBox.localToGlobal(Offset.zero);

    final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
    final widgetBottomPosition =
        widgetPosition.dy + widgetRenderBox.size.height;

    final visible = widgetPosition.dy >= listPosition.dy &&
        widgetBottomPosition <= (listPosition.dy + listSize.height);

    return visible;
  }
}
