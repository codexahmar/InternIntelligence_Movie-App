import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'Your API Key';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<Movie>> getTrendingMovies({String timeWindow = 'day'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/movie/$timeWindow?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,similar',
      ),
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> getRecommendedMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId/recommendations?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load recommended movies');
    }
  }

  String getImageUrl(String path) {
    return '$imageBaseUrl$path';
  }
}
