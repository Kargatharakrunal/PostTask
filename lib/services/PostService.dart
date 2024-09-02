import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krunalpractical/model/Post.dart';

class PostService {
  // Base URL
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Fetch Post data
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      throw Exception('Network error:');
    }
  }


  // Fetch Post details data using post id
  Future<Post> fetchPostDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post details');
      }
    } catch (error) {
      throw Exception('Network error:');
    }
  }
}
