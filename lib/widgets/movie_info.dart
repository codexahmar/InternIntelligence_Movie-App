import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieInfo extends StatelessWidget {
  final Movie movie;

  const MovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600]),
            const SizedBox(width: 4),
            Text(
              movie.rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            Text(
              movie.releaseDate.split('-')[0],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(movie.overview, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
