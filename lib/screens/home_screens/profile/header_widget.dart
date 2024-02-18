import 'package:cached_network_image/cached_network_image.dart';
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
        CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imgUrl,
          imageBuilder: (context, imageProvider) => Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
            child: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
