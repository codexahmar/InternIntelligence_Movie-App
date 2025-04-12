import 'package:flutter/material.dart';
import 'package:movie_app/providers/recommendation_provider.dart';
import 'package:movie_app/providers/user_provider.dart';
import 'package:movie_app/screens/auth/login_screen.dart';
import 'package:movie_app/widgets/buttons.dart';
import 'package:movie_app/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class RecommendedMovies extends StatelessWidget {
  const RecommendedMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.currentUser == null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sign in to get personalized recommendations',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Buttons(
                      title: 'Sign Up',
                      isLoading: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Consumer<RecommendationProvider>(
          builder: (context, recommendationProvider, _) {
            if (recommendationProvider.isLoading) {
              return const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (recommendationProvider.recommendedMovies.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No recommendations available yet'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Recommended for You',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recommendationProvider.recommendedMovies.length,
                    itemBuilder: (context, index) {
                      final movie =
                          recommendationProvider.recommendedMovies[index];
                      return SizedBox(
                        width: 160,
                        child: MovieCard(movie: movie),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
