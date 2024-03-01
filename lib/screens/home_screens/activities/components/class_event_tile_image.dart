import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      child: imgUrl != null
          ? Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  foregroundDecoration: isCancelled == true
                      ? const BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode.saturation,
                        )
                      : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      width: width,
                      height: CLASS_CARD_HEIGHT,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                      imageUrl: imgUrl!,
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
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8.0)),
            ),
    );
  }
}
