import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/presentation/shared_components/images/custom_cached_network_image.dart';
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
              aspectRatio: AspectRatios.ar_1_1,
              child: Container(
                foregroundDecoration: isCancelled == true
                    ? const BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      )
                    : null,
                child: ClipRRect(
                  borderRadius: AppBorders.smallRadius,
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
