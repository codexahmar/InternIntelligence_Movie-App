import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/movie_app_bar.dart';
import '../widgets/movie_info.dart';
import '../widgets/movie_rating_section.dart';
import '../widgets/movie_reviews_section.dart';
import '../widgets/similar_movies_section.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovieDetails();
    });
  }

  Future<void> _loadMovieDetails() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final recommendationProvider = Provider.of<RecommendationProvider>(
      context,
      listen: false,
    );

    await movieProvider.fetchMovieDetails(widget.movieId);
    if (movieProvider.selectedMovie != null) {
      await recommendationProvider.getSimilarMovies(
        movieProvider.selectedMovie!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, _) {
          final movie = movieProvider.selectedMovie;
          if (movie == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              MovieAppBar(movie: movie, movieProvider: movieProvider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieInfo(movie: movie),
                      const SizedBox(height: 24),
                      MovieRatingSection(
                        movieId: movie.id,
                        reviewController: _reviewController,
                      ),
                      const SizedBox(height: 24),
                      MovieReviewsSection(movieId: movie.id),
                      const SizedBox(height: 24),
                      const SimilarMoviesSection(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
