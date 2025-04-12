import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> Function(MovieProvider) moviesGetter;

  const MovieSection({
    super.key,
    required this.title,
    required this.moviesGetter,
  });

  @override
  Widget build(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: Consumer<MovieProvider>(
            builder: (context, movieProvider, child) {
              final movies = moviesGetter(movieProvider);

              if (movieProvider.isLoading && movies.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (movies.isEmpty) {
                return Center(
                  child: Text('No ${title.toLowerCase()} movies available'),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: MovieCard(movie: movies[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
