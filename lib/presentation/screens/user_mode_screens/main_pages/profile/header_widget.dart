import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.imgUrl, required this.name});

  final String imgUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomAvatarCachedNetworkImage(
          imageUrl: imgUrl,
          radius: 37.5, // 75/2
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
