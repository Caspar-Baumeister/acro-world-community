import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView({super.key, required this.url, required this.tag});

  final String url;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: PhotoViewGallery(
              pageOptions: <PhotoViewGalleryPageOptions>[
                PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(url),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
