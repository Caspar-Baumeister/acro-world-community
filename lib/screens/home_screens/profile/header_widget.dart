import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key, required this.imgUrl, required this.name})
      : super(key: key);

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
          width: 75,
          errorWidget: (context, url, error) => Container(
            width: 100.0,
            height: 100.0,
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
        Text(
          name,
          textAlign: TextAlign.start,
          style: H20W5,
        ),
      ],
    );
  }
}
