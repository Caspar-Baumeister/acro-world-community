import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
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
        decoration: const BoxDecoration(
          // rounded image
          shape: BoxShape.circle,
          color: CustomColors.secondaryBackgroundColor,
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
        decoration: const BoxDecoration(
          color: CustomColors.secondaryBackgroundColor,
          shape: BoxShape.circle,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.secondaryBackgroundColor,
        ),
        child: const Icon(
          Icons.error,
          color: CustomColors.errorTextColor,
          size: AppDimensions.iconSizeMedium,
        ),
      ),
    );
  }
}
