import 'dart:ui';

import 'package:acroworld/presentation/components/images/fullscreen_image_wrapper.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.actions,
    required ValueNotifier<double> percentageCollapsed,
    required this.headerText,
    required this.imgUrl,
    this.tag,
  }) : _percentageCollapsed = percentageCollapsed;

  final List<Widget> actions;
  final ValueNotifier<double> _percentageCollapsed;
  final String headerText;
  final String imgUrl;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    // same as before
    final expandedHeight = kIsWeb ? 550.0 : appBarExpandedHeight;

    // dial this down to taste:
    const double blurSigma = 5.0;
    return SliverAppBar(
      actions: actions,
      centerTitle: false,
      leading: ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          return BlurIconButton(
            isCollapsed: percentage > appBarCollapsedThreshold,
          );
        },
      ),
      title: ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          if (percentage > appBarCollapsedThreshold) {
            return Text(headerText,
                maxLines: 3,
                style: const TextStyle(color: Colors.black, fontSize: 18));
          }
          return Container(); // Empty container when expanded
        },
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      expandedHeight: !kIsWeb ? appBarExpandedHeight : 550.0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: kIsWeb
            ? Stack(
                fit: StackFit.expand,
                children: [
                  // 1) very lightly blurred, full‐bleed background
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.black12),
                      errorWidget: (_, __, ___) => Container(
                          color: Colors.black12,
                          child: Icon(Icons.error, color: Colors.red)),
                    ),
                  ),

                  // 2) square, non-blurred image exactly as tall as the bar
                  Center(
                    child: SizedBox(
                      height: expandedHeight,
                      width: expandedHeight, // makes it a perfect square
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.black12),
                        errorWidget: (_, __, ___) => Container(
                            color: Colors.black12,
                            child: Icon(Icons.error, color: Colors.red)),
                      ),
                    ),
                  ),
                ],
              )
            : (tag != null
                // your existing FullscreenImageWrapper branch
                ? FullscreenImageWrapper(
                    imgChild: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: !kIsWeb ? 52.0 : 550.0,
                      /* … */
                      imageUrl: imgUrl,
                    ),
                    tag: tag!,
                    imgUrl: imgUrl,
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: !kIsWeb ? 52.0 : 550.0,
                    /* … */
                    imageUrl: imgUrl,
                  )),
      ),
    );
  }
}

class BlurIconButton extends StatelessWidget {
  const BlurIconButton({super.key, required this.isCollapsed});

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    double blurFactor = isCollapsed ? 0 : 4;

    return ClipOval(
      child: GestureDetector(
        onTap: () {
          if (!Navigator.canPop(context)) {
            // nothing to pop
            context.go('/');
          } else {
            // pop the current screen
            context.pop();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Subdued color
            shape: BoxShape.circle, // Circular shape
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurFactor, sigmaY: blurFactor),
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
