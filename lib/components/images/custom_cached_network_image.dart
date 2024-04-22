import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage(
      {super.key, this.imageUrl, this.width, this.height, this.borderRadius});

  final String? imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
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
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            borderRadius: borderRadius),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackgroundColor,
          borderRadius: borderRadius,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackgroundColor,
          borderRadius: borderRadius,
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
