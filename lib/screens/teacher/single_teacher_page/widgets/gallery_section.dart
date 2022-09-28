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
        return Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(pictureUrls[index]),
          ),
        ));
        // Item rendering
      },
    );
  }
}
