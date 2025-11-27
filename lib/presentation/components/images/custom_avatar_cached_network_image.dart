import 'package:acroworld/theme/app_dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomAvatarCachedNetworkImage extends StatelessWidget {
  const CustomAvatarCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.radius,
  });

  final String? imageUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    double width = radius ?? AppDimensions.avatarSizeMedium;
    double height = radius ?? AppDimensions.avatarSizeMedium;

    if (imageUrl == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // rounded image
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
      );
    }
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: AppDimensions.iconSizeMedium,
        ),
      ),
    );
  }
}
