import 'package:flutter/foundation.dart';
import '../models/review.dart';

class ReviewProvider with ChangeNotifier {
  final Map<int, List<Review>> _movieReviews = {};
  bool _isLoading = false;

  Map<int, List<Review>> get movieReviews => _movieReviews;
  bool get isLoading => _isLoading;

  List<Review> getReviewsForMovie(int movieId) {
    return _movieReviews[movieId] ?? [];
  }

  double getAverageRating(int movieId) {
    final reviews = _movieReviews[movieId];
    if (reviews == null || reviews.isEmpty) {
      return 0.0;
    }

    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  void addReview(Review review) {
    if (!_movieReviews.containsKey(review.movieId)) {
      _movieReviews[review.movieId] = [];
    }
    _movieReviews[review.movieId]!.add(review);
    notifyListeners();
  }

  void removeReview(String reviewId, int movieId) {
    if (_movieReviews.containsKey(movieId)) {
      _movieReviews[movieId]!.removeWhere((review) => review.id == reviewId);
      notifyListeners();
    }
  }

  void updateReview(Review updatedReview) {
    if (_movieReviews.containsKey(updatedReview.movieId)) {
      final index = _movieReviews[updatedReview.movieId]!.indexWhere(
        (review) => review.id == updatedReview.id,
      );

      if (index != -1) {
        _movieReviews[updatedReview.movieId]![index] = updatedReview;
        notifyListeners();
      }
    }
  }

  List<Review> getUserReviews(String userId) {
    List<Review> userReviews = [];
    _movieReviews.forEach((_, reviews) {
      userReviews.addAll(reviews.where((review) => review.userId == userId));
    });
    return userReviews;
  }
}
