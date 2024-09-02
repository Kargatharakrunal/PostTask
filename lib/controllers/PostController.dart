import 'package:get/get.dart';

import '../model/Post.dart';
import '../screens/PostDetailScreen.dart';
import '../services/PostService.dart';
import '../utils/SharedPreferences.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs; // set Post
  var isLoading = true.obs; // set boolean for post loading
  final visiblePostIds = <int>{}.obs; // Set to track visible post IDs
  var postDetail = Rxn<Post>(); // Reactive variable for post details

  final PostService postService = PostService();

  // Local Storage SharedPref
  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void onInit() {
    super.onInit();
    // Load post data
    loadPosts();
  }

  void loadPosts() async {
    try {
      isLoading(true);
      // get fro sharedPref & set
      var localPosts = await _localStorageService.loadPosts();
      if (localPosts.isNotEmpty) {
        posts.assignAll(localPosts);
      }

      // Fetch From API & set
      var fetchedPosts = await postService.fetchPosts();
      posts.assignAll(fetchedPosts);

      _localStorageService.savePosts(posts);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void markAsReadAndNavigate(Post post) {
    post.isRead = true;
    pauseTimer(post);  // Pause the timer when navigating to PostDetailScreen
    posts.refresh();
    _localStorageService.savePosts(posts);
    Get.to(() => PostDetailScreen(postId: post.id))!.then((_) => resumeTimer(post)); // Resume timer when come back to screen
  }

  // Start Timer with post
  void startTimer(Post post) {
    if (!post.isTimerRunning && post.remainingTime > 0) {
      post.isTimerRunning = true;
      _runTimer(post);
    }
  }


  // Run Timer with post
  void _runTimer(Post post) {
    Future.delayed(const Duration(seconds: 1), () {
      if (post.isTimerRunning && post.remainingTime > 0) {
        post.remainingTime--;
        posts.refresh();

        if (post.remainingTime > 0) {
          _runTimer(post);
        } else {
          post.isTimerRunning = false;
        }
      }
    });
  }


  // Pause Timer with post
  void pauseTimer(Post post) {
    post.isTimerRunning = false;
  }

  // Resume Timer with Post
  void resumeTimer(Post post) {
    if (!post.isTimerRunning && post.remainingTime > 0) {
      startTimer(post);
    }
  }

  // Here set Visible Post IDs
  void setVisiblePostIds(Set<int> visiblePostIds) {
    visiblePostIds.assignAll(visiblePostIds);
    for (var post in posts) {
      if (visiblePostIds.contains(post.id)) {
        resumeTimer(post);
      } else {
        pauseTimer(post);
      }
    }
  }

  void fetchPostDetails(int postId) async {
    try {
      isLoading(true);

      // Fetch post from API
      var fetchedPost = await postService.fetchPostDetail(postId);

      // Update the reactive variable with fetched data
      postDetail.value = fetchedPost;

    } catch (e) {
      // Handle errors if needed
      print('Error fetching post details: $e');
    } finally {
      isLoading(false);
    }
  }
}
