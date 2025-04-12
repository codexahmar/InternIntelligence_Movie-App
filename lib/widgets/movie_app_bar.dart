import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class MovieAppBar extends StatelessWidget {
  final Movie movie;
  final MovieProvider movieProvider;

  const MovieAppBar({
    super.key,
    required this.movie,
    required this.movieProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movieProvider.getImageUrl(movie.backdropPath),
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
        title: Text(movie.title),
      ),
      actions: [
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final isFavorite = userProvider.isFavorite(movie.id);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                if (userProvider.currentUser != null) {
                  await userProvider.toggleFavorite(movie.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please sign in to add favorites'),
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
