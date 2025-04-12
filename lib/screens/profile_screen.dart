import 'package:flutter/material.dart';
import 'package:movie_app/models/review.dart';
import 'package:movie_app/widgets/buttons.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/review_provider.dart';
import 'movie_details_screen.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle, size: 100),
                  const SizedBox(height: 16),
                  Text(
                    'Please sign in to view your profile',
                    style: Theme.of(context).textTheme.titleLarge,
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
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(userProvider.currentUser!.name),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.account_circle, size: 100),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await userProvider.logout();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully logged out'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(userProvider.currentUser!.email),
                      const SizedBox(height: 24),
                      Text(
                        'Preferences',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            userProvider.currentUser!.preferences
                                .map(
                                  (genre) => Chip(
                                    label: Text(genre),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.2),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Your Reviews',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Consumer<ReviewProvider>(
                        builder: (context, reviewProvider, _) {
                          final userReviews = reviewProvider.getUserReviews(
                            userProvider.currentUser!.id,
                          );
                          if (userReviews.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text('No reviews yet'),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userReviews.length,
                            itemBuilder: (context, index) {
                              final review = userReviews[index];
                              return Card(
                                // margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(review.rating.toString()),
                                    ],
                                  ),
                                  subtitle: Text(review.comment),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              final commentController =
                                                  TextEditingController(
                                                    text: review.comment,
                                                  );
                                              double updatedRating =
                                                  review.rating;

                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Edit Review',
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              commentController,
                                                          decoration:
                                                              const InputDecoration(
                                                                labelText:
                                                                    'Comment',
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Rating: ',
                                                            ),
                                                            Expanded(
                                                              child: Slider(
                                                                value:
                                                                    updatedRating,
                                                                onChanged: (
                                                                  value,
                                                                ) {
                                                                  setState(() {
                                                                    updatedRating =
                                                                        value;
                                                                  });
                                                                },
                                                                divisions: 10,
                                                                label:
                                                                    updatedRating
                                                                        .toString(),
                                                                min: 0.0,
                                                                max: 5.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          final updatedReview = Review(
                                                            userName:
                                                                userProvider
                                                                    .currentUser!
                                                                    .name,
                                                            id: review.id,
                                                            movieId:
                                                                review.movieId,
                                                            userId:
                                                                review.userId,
                                                            rating:
                                                                updatedRating,
                                                            comment:
                                                                commentController
                                                                    .text,
                                                            timestamp:
                                                                DateTime.now(),
                                                          );
                                                          Provider.of<
                                                            ReviewProvider
                                                          >(
                                                            context,
                                                            listen: false,
                                                          ).updateReview(
                                                            updatedReview,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Update',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          Provider.of<ReviewProvider>(
                                            context,
                                            listen: false,
                                          ).removeReview(
                                            review.id,
                                            review.movieId,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Favorite Movies',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Consumer<MovieProvider>(
                        builder: (context, movieProvider, _) {
                          final favoriteMovies =
                              userProvider.currentUser!.favoriteMovies;

                          if (favoriteMovies.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text('No favorite movies yet'),
                            );
                          }

                          // Fetch favorite movies data
                          movieProvider.fetchFavoriteMovies(favoriteMovies);

                          return SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: favoriteMovies.length,
                              itemBuilder: (context, index) {
                                final movieId = favoriteMovies[index];
                                final movie =
                                    movieProvider.favoriteMovies[movieId];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MovieDetailsScreen(
                                              movieId: movieId,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Card(
                                      child:
                                          movie != null
                                              ? Image.network(
                                                movieProvider.getImageUrl(
                                                  movie.posterPath,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    color: Colors.grey[800],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.movie,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                              : Container(
                                                color: Colors.grey[800],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
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
}
