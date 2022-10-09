import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({Key? key, required this.pictureUrls}) : super(key: key);
  final List<String> pictureUrls;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
      ),
      itemCount: pictureUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
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
          imageUrl: pictureUrls[index],
        );
        // Item rendering
      },
    );
  }
}
