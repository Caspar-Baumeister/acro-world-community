import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    super.key,
    required this.onRatingChanged,
    this.initialRating = 0,
    this.maxRating = 5,
    this.size = 32.0,
    this.allowHalfRating = false,
  });

  final ValueChanged<int> onRatingChanged;
  final int initialRating;
  final int maxRating;
  final double size;
  final bool allowHalfRating;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  void didUpdateWidget(StarRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              size: widget.size,
              color: index < _currentRating
                  ? colorScheme.primary
                  : colorScheme.outline,
            ),
          ),
        );
      }),
    );
  }
}
