class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final List<String> genres;
  final double rating;
  final String backdropPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.genres,
    required this.rating,
    required this.backdropPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> extractGenres() {
      if (json['genres'] != null) {
        return List<String>.from(json['genres'].map((genre) => genre['name']));
      }
      if (json['genre_ids'] != null) {

        final genreMap = {
          28: 'Action',
          12: 'Adventure',
          16: 'Animation',
          35: 'Comedy',
          80: 'Crime',
          99: 'Documentary',
          18: 'Drama',
          10751: 'Family',
          14: 'Fantasy',
          27: 'Horror',
          9648: 'Mystery',
          10749: 'Romance',
          878: 'Sci-Fi',
          53: 'Thriller',
          10752: 'War',
        };
        return List<String>.from(
          json['genre_ids'].map((id) => genreMap[id] ?? 'Unknown'),
        );
      }
      return [];
    }

    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genres: extractGenres(),
      rating: (json['vote_average'] ?? 0.0).toDouble(),
      backdropPath: json['backdrop_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'genres': genres,
      'vote_average': rating,
      'backdrop_path': backdropPath,
    };
  }
}
