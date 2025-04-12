import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/recommendation_service.dart';

class RecommendationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final RecommendationService _recommendationService = RecommendationService();

  List<Movie> _recommendedMovies = [];
  List<Movie> _similarMovies = [];
  bool _isLoading = false;

  List<Movie> get recommendedMovies => _recommendedMovies;
  List<Movie> get similarMovies => _similarMovies;
  bool get isLoading => _isLoading;

  Future<void> getPersonalizedRecommendations(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final allMovies = await _apiService.getTrendingMovies();
      _recommendedMovies = _recommendationService
          .getPersonalizedRecommendations(user, allMovies);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getSimilarMovies(Movie movie) async {
    _isLoading = true;
    notifyListeners();

    try {
      final allMovies = await _apiService.getTrendingMovies();
      _similarMovies = _recommendationService.getSimilarMovies(
        movie,
        allMovies,
      );
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearRecommendations() {
    _recommendedMovies = [];
    _similarMovies = [];
    notifyListeners();
  }
}
