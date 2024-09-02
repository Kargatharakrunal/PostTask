import 'dart:math';

class Post {
  final int id;
  final String title;
  final String body;
  bool isRead;
  int timerDuration; // Time duration in seconds
  int remainingTime; // Remaining time in seconds
  bool isTimerRunning; //Timer currently run time in second

  Post({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    int? timerDuration,
    int? remainingTime,
    this.isTimerRunning = false,
  })  : timerDuration = timerDuration ?? _generateRandomDuration(),
        remainingTime = remainingTime ?? timerDuration ?? _generateRandomDuration();

  factory Post.fromJson(Map<String, dynamic> json) {
    int randomTimerDuration = _generateRandomDuration();
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timerDuration: randomTimerDuration,
      remainingTime: randomTimerDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isRead': isRead,
      'timerDuration': timerDuration,
      'remainingTime': remainingTime,
      'isTimerRunning': isTimerRunning,
    };
  }


  // generate Random Time Duration each post
  static int _generateRandomDuration() {
    final random = Random();
    final durations = [10, 20, 25];
    return durations[random.nextInt(durations.length)];
  }
}
