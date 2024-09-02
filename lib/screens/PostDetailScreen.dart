import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/PostController.dart';
import '../model/Post.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  PostDetailScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();


    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: FutureBuilder(
        future: postController.postService.fetchPostDetail(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final post = snapshot.data as Post;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(post.body),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
