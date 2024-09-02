import 'package:flutter/material.dart';

import '../model/Post.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final VoidCallback onReadAndNavigate;
  final VoidCallback onTimerTap;

  PostListItem({
    required this.post,
    required this.onReadAndNavigate,
    required this.onTimerTap,
    required Key key, // unique key is passed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body),
      tileColor: post.isRead ? Colors.white : Colors.yellow[100],
      trailing: GestureDetector(
        onTap: onTimerTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer),
            Text('${post.remainingTime}s'), // Display the remaining time
          ],
        ),
      ),
      onTap: onReadAndNavigate,
    );
  }
}
