import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Movie> _trendingDailyMovies = [];
  List<Movie> _trendingWeeklyMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _recommendedMovies = [];
  Movie? _selectedMovie;
  bool _isLoading = false;

  Map<int, Movie> _favoriteMovies = {};

  List<Movie> get trendingDailyMovies => _trendingDailyMovies;
  List<Movie> get trendingWeeklyMovies => _trendingWeeklyMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get recommendedMovies => _recommendedMovies;
  Movie? get selectedMovie => _selectedMovie;
  bool get isLoading => _isLoading;
  Map<int, Movie> get favoriteMovies => _favoriteMovies;

  Future<void> fetchTrendingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch both daily and weekly trending movies
      _trendingDailyMovies = await _apiService.getTrendingMovies(
        timeWindow: 'day',
      );
      _trendingWeeklyMovies = await _apiService.getTrendingMovies(
        timeWindow: 'week',
      );
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _popularMovies = await _apiService.getPopularMovies();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchTopRatedMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _topRatedMovies = await _apiService.getTopRatedMovies();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _upcomingMovies = await _apiService.getUpcomingMovies();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _nowPlayingMovies = await _apiService.getNowPlayingMovies();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedMovie = await _apiService.getMovieDetails(movieId);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchRecommendedMovies(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _recommendedMovies = await _apiService.getRecommendedMovies(movieId);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchFavoriteMovies(List<int> movieIds) async {
    for (final movieId in movieIds) {
      if (!_favoriteMovies.containsKey(movieId)) {
        try {
          final movie = await _apiService.getMovieDetails(movieId);
          _favoriteMovies[movieId] = movie;
          notifyListeners();
        } catch (error) {
          debugPrint('Error fetching movie $movieId: $error');
        }
      }
    }
  }

  void clearSelectedMovie() {
    _selectedMovie = null;
    _searchResults = [];
    notifyListeners();
  }

  String getImageUrl(String path) {
    return _apiService.getImageUrl(path);
  }
}
