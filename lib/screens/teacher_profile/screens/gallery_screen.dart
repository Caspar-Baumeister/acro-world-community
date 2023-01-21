import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required this.pictureUrls}) : super(key: key);
  final List<String> pictureUrls;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  OverlayEntry? _popupDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: widget.pictureUrls.map(_createGridTileWidget).toList(),
      ),
    );
  }

  Widget _createGridTileWidget(String url) => Builder(
        builder: (context) => GestureDetector(
          onLongPress: () {
            _popupDialog = _createPopupDialog(url);
            Overlay.of(context)?.insert(_popupDialog!);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
          child: CachedNetworkImage(
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
            imageUrl: url,
          ),
        ),
      );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPopupContent(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
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
                imageUrl: url,
              )
            ],
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
