import '../models/movie.dart';
import '../models/user.dart';

class RecommendationService {
  List<Movie> getPersonalizedRecommendations(User user, List<Movie> allMovies) {
    // If user has no preferences, favorites, and no watch history, return trending movies
    if (user.preferences.isEmpty &&
        user.watchHistory.isEmpty &&
        user.favoriteMovies.isEmpty) {
      return allMovies;
    }


    Map<String, double> genreWeights = {};


    for (var genre in user.preferences) {
      genreWeights[genre] =
          2.0; 
    }


    for (var movieId in user.favoriteMovies) {
      var movie = allMovies.firstWhere(
        (m) => m.id == movieId,
        orElse: () => allMovies.first,
      );
      for (var genre in movie.genres) {
        genreWeights[genre] = (genreWeights[genre] ?? 0.0) + 1.5;
      }
    }


    for (var movieId in user.watchHistory) {
      var movie = allMovies.firstWhere(
        (m) => m.id == movieId,
        orElse: () => allMovies.first,
      );
      for (var genre in movie.genres) {
        genreWeights[genre] = (genreWeights[genre] ?? 0.0) + 1.0;
      }
    }

    List<MapEntry<Movie, double>> scoredMovies =
        allMovies.map((movie) {
          double score = 0.0;

          for (var genre in movie.genres) {
            score += genreWeights[genre] ?? 0.0;
          }


          score += (movie.rating / 10.0) * 2.0; 


          if (user.watchHistory.contains(movie.id) ||
              user.favoriteMovies.contains(movie.id)) {
            score = 0.0;
          }

          return MapEntry(movie, score);
        }).toList();


    scoredMovies.sort((a, b) => b.value.compareTo(a.value));


    return scoredMovies
        .where((entry) => entry.value > 0.0)
        .take(20)
        .map((entry) => entry.key)
        .toList();
  }

  List<Movie> getSimilarMovies(Movie movie, List<Movie> allMovies) {
    // Score movies based on genre similarity and rating
    var scoredMovies =
        allMovies.where((m) => m.id != movie.id).map((m) {
          double score = 0.0;

          // Calculate genre similarity (higher weight)
          int commonGenres =
              m.genres.where((genre) => movie.genres.contains(genre)).length;
          score += commonGenres * 3.0;

          // Add rating factor
          score += (m.rating / 10.0) * 2.0;

          // Boost score if release years are close
          int movieYear = int.tryParse(movie.releaseDate.split('-')[0]) ?? 0;
          int otherYear = int.tryParse(m.releaseDate.split('-')[0]) ?? 0;
          if (movieYear > 0 && otherYear > 0) {
            int yearDiff = (movieYear - otherYear).abs();
            if (yearDiff <= 5) {
              score += (5 - yearDiff) * 0.5; // More points for closer years
            }
          }

          return MapEntry(m, score);
        }).toList();

    // Sort by score (descending)
    scoredMovies.sort((a, b) => b.value.compareTo(a.value));

    // Return top 10 similar movies
    return scoredMovies.take(10).map((entry) => entry.key).toList();
  }
}
