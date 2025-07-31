import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class ClassEventTileImage extends StatelessWidget {
  const ClassEventTileImage(
      {super.key, required this.width, this.imgUrl, required this.isCancelled});

  final double width;
  final String? imgUrl;
  final bool? isCancelled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                foregroundDecoration: isCancelled == true
                    ? const BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      )
                    : null,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                  child: CustomCachedNetworkImage(
                    imageUrl: imgUrl,
                  ),
                ),
              ),
            ),
            isCancelled == true
                ? const RotationTransition(
                    turns: AlwaysStoppedAnimation(345 / 360),
                    child: Text(
                      "Canceled",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                : Container()
          ],
        ));
  }
}
