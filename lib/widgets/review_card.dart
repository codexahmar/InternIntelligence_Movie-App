import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../providers/user_provider.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ReviewCard({Key? key, required this.review, this.onDelete, this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isCurrentUserReview = userProvider.currentUser?.id == review.userId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isCurrentUserReview)
                  Row(
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                          iconSize: 20,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: onDelete,
                          iconSize: 20,
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            RatingStars(rating: review.rating),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 4),
            Text(
              _formatDate(review.timestamp),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
