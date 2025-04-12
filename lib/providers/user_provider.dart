import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _storageService.getCurrentUser();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    List<String> preferences,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = User(
        id: DateTime.now().toString(),
        name: name,
        email: email,
        password: password,
        preferences: preferences,
        watchHistory: [],
        favoriteMovies: [],
      );

      await _storageService.saveUser(user);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _storageService.login(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.logout();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePreferences(List<String> preferences) async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(preferences: preferences);
      await _storageService.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  Future<void> addToWatchHistory(int movieId) async {
    if (_currentUser != null) {
      final watchHistory = List<int>.from(_currentUser!.watchHistory);
      if (!watchHistory.contains(movieId)) {
        watchHistory.add(movieId);
        final updatedUser = _currentUser!.copyWith(watchHistory: watchHistory);
        await _storageService.updateUser(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
      }
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    if (_currentUser != null) {
      final favorites = List<int>.from(_currentUser!.favoriteMovies);
      if (favorites.contains(movieId)) {
        favorites.remove(movieId);
      } else {
        favorites.add(movieId);
      }

      final updatedUser = _currentUser!.copyWith(favoriteMovies: favorites);
      await _storageService.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  bool isFavorite(int movieId) {
    return _currentUser?.favoriteMovies.contains(movieId) ?? false;
  }
}
