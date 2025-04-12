import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Function(double)? onRatingChanged;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 24,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;
        final isHalf = rating > index && rating < value;
        final isFull = rating >= value;

        return GestureDetector(
          onTap:
              onRatingChanged != null
                  ? () => onRatingChanged!(value.toDouble())
                  : null,
          child: Icon(
            isFull
                ? Icons.star
                : isHalf
                ? Icons.star_half
                : Icons.star_border,
            color: Colors.amber,
            size: size,
          ),
        );
      }),
    );
  }
}
