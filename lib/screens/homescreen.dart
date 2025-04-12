import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_section.dart';
import 'package:movie_app/widgets/recommended_movies.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/user_provider.dart';
import '../providers/recommendation_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovies();
    });
  }

  Future<void> _loadMovies() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await Future.wait([
        movieProvider.fetchTrendingMovies(),
        movieProvider.fetchPopularMovies(),
        movieProvider.fetchTopRatedMovies(),
        movieProvider.fetchUpcomingMovies(),
        movieProvider.fetchNowPlayingMovies(),
      ]);

      if (userProvider.currentUser != null) {
        await Provider.of<RecommendationProvider>(
          context,
          listen: false,
        ).getPersonalizedRecommendations(userProvider.currentUser!);
      }
    } catch (e) {
      debugPrint('Error loading movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMovies),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMovies,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecommendedMovies(),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Now Playing',
                moviesGetter: (provider) => provider.nowPlayingMovies,
              ),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Trending Today',
                moviesGetter: (provider) => provider.trendingDailyMovies,
              ),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Trending This Week',
                moviesGetter: (provider) => provider.trendingWeeklyMovies,
              ),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Popular',
                moviesGetter: (provider) => provider.popularMovies,
              ),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Top Rated',
                moviesGetter: (provider) => provider.topRatedMovies,
              ),
              const SizedBox(height: 24),
              MovieSection(
                title: 'Upcoming',
                moviesGetter: (provider) => provider.upcomingMovies,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
