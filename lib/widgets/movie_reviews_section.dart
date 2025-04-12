import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class MovieReviewsSection extends StatelessWidget {
  final int movieId;

  const MovieReviewsSection({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, _) {
        final reviews = reviewProvider.getReviewsForMovie(movieId);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviews', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (reviews.isEmpty)
              const Text('No reviews yet')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(review.rating.toString()),
                              const Spacer(),
                              Text(
                                review.timestamp.toString().split(' ')[0],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
