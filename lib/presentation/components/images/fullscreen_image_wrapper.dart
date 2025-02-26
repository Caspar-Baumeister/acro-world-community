import 'package:acroworld/presentation/components/full_screen_view.dart';
import 'package:flutter/material.dart';

class FullscreenImageWrapper extends StatelessWidget {
  const FullscreenImageWrapper(
      {super.key,
      required this.imgChild,
      required this.tag,
      required this.imgUrl});

  final Widget imgChild;
  final String tag;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    FullScreenImageView(url: imgUrl, tag: tag),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const Curve curve = Curves.easeInOut;
                  var scale = Tween<double>(
                    begin: begin,
                    end: end,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: curve),
                  );

                  return ScaleTransition(
                    scale: scale,
                    child: child,
                  );
                },
              ),
            ),
        child: Hero(
          tag: tag,
          child: imgChild,
        ));
  }
}
