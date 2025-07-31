import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class EventCardImageSection extends StatelessWidget {
  const EventCardImageSection({
    super.key,
    required this.imageUrl,
    required this.isHighlighted,
  });

  final String? imageUrl;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            CustomCachedNetworkImage(
              imageUrl: imageUrl,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            isHighlighted
                ? Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSmall)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                AppDimensions.spacingExtraSmall),
                            child: Text(
                              "Highlight",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                          ),
                        )),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
