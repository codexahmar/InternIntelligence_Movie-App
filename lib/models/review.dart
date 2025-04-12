class Review {
  final String id;
  final String userId;
  final int movieId;
  final double rating;
  final String comment;
  final DateTime timestamp;
  final String userName;

  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.comment,
    required this.timestamp,
    required this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      userName: json['user_name'] ?? 'Anonymous',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
      'user_name': userName,
    };
  }
}
