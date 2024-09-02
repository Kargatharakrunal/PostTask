import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/Post.dart';

class LocalStorageService {

  // Save post data
  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final String postsJson = json.encode(posts.map((post) => post.toJson()).toList());
    await prefs.setString('posts', postsJson);
  }

  // load Post data
  Future<List<Post>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString('posts');
    if (postsJson != null) {
      List jsonResponse = json.decode(postsJson);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      return [];
    }
  }
}
