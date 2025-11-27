import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:acroworld/presentation/components/backgrounds/dynamic_gradient_background.dart';

class FullScreenImageView extends ConsumerWidget {
  const FullScreenImageView({super.key, required this.url, required this.tag});

  final String url;
  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            // Dynamic gradient background
            SimpleDynamicBackground(
              coverUrl: url,
              child: Container(
                alignment: Alignment.center,
                child: Hero(
                  tag: tag,
                  child: PhotoViewGallery(
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
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
            // Back button with better visibility
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
