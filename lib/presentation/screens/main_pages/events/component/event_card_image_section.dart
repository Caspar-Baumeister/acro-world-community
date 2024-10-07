import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/presentation/shared_components/images/custom_cached_network_image.dart';
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
      aspectRatio: AspectRatios.ar_1_1,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            CustomCachedNetworkImage(
              imageUrl: imageUrl,
              borderRadius: AppBorders.smallRadius,
            ),
            isHighlighted
                ? Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                        decoration: BoxDecoration(
                            color: CustomColors.accentColor,
                            borderRadius: AppBorders.smallRadius),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppPaddings.tiny),
                            child: Text(
                              "Highlight",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: CustomColors.whiteTextColor,
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
