import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';
import '../providers/user_provider.dart';
import '../providers/recommendation_provider.dart';

class MovieRatingSection extends StatefulWidget {
  final int movieId;
  final TextEditingController reviewController;

  const MovieRatingSection({
    super.key,
    required this.movieId,
    required this.reviewController,
  });

  @override
  State<MovieRatingSection> createState() => _MovieRatingSectionState();
}

class _MovieRatingSectionState extends State<MovieRatingSection> {
  double _userRating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate this movie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _userRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _userRating.toString(),
                    onChanged: (value) {
                      setState(() {
                        _userRating = value;
                      });
                    },
                  ),
                ),
                Text(
                  _userRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.reviewController,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitReview(context),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    if (userProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to submit a review')),
      );
      return;
    }

    if (widget.reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review comment')),
      );
      return;
    }

    final review = Review(
      id: DateTime.now().toString(),
      movieId: widget.movieId,
      userId: userProvider.currentUser!.id,
      rating: _userRating,
      comment: widget.reviewController.text.trim(),
      timestamp: DateTime.now(),
      userName: userProvider.currentUser!.name,
    );

    reviewProvider.addReview(review);
    userProvider.addToWatchHistory(widget.movieId);
    widget.reviewController.clear();
    setState(() {
      _userRating = 3.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Update recommendations after submitting a review
    context.read<RecommendationProvider>().getPersonalizedRecommendations(
      userProvider.currentUser!,
    );
  }
}
