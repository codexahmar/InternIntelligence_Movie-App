class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final List<String> preferences;
  final List<int> watchHistory;
  final List<int> favoriteMovies;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.preferences,
    required this.watchHistory,
    required this.favoriteMovies,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      preferences: List<String>.from(json['preferences'] ?? []),
      watchHistory: List<int>.from(json['watch_history'] ?? []),
      favoriteMovies: List<int>.from(json['favorite_movies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'preferences': preferences,
      'watch_history': watchHistory,
      'favorite_movies': favoriteMovies,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    List<String>? preferences,
    List<int>? watchHistory,
    List<int>? favoriteMovies,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      preferences: preferences ?? this.preferences,
      watchHistory: watchHistory ?? this.watchHistory,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
    );
  }
}
