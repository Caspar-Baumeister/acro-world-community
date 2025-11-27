import 'dart:ui';

import 'package:acroworld/presentation/components/images/fullscreen_image_wrapper.dart';
import 'package:acroworld/theme/app_dimensions.dart';
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
    this.isCancelled = false,
  }) : _percentageCollapsed = percentageCollapsed;

  final List<Widget> actions;
  final ValueNotifier<double> _percentageCollapsed;
  final String headerText;
  final String imgUrl;
  final String? tag;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    // same as before
    final expandedHeight = kIsWeb ? 550.0 : AppDimensions.appBarExpandedHeight;

    // dial this down to taste:
    const double blurSigma = 5.0;
    return SliverAppBar(
      actions: actions,
      centerTitle: false,
      leading: ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          return BlurIconButton(
            isCollapsed: percentage > AppDimensions.appBarCollapsedThreshold,
          );
        },
      ),
      title: ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          if (percentage > AppDimensions.appBarCollapsedThreshold) {
            return Text(headerText,
                maxLines: 3,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface));
          }
          return Container(); // Empty container when expanded
        },
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      expandedHeight: !kIsWeb ? AppDimensions.appBarExpandedHeight : 550.0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (kIsWeb)
              // Web-specific background with blur
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: blurSigma,
                  sigmaY: blurSigma,
                ),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Theme.of(context).colorScheme.surfaceContainer),
                  errorWidget: (_, __, ___) =>
                      Container(color: Theme.of(context).colorScheme.surfaceContainer, child: Icon(Icons.error, color: Theme.of(context).colorScheme.error)),
                ),
              ),
            if (kIsWeb)
              Center(
                child: SizedBox(
                  height: expandedHeight,
                  width: expandedHeight,
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Theme.of(context).colorScheme.surfaceContainer),
                    errorWidget: (_, __, ___) =>
                        Container(color: Theme.of(context).colorScheme.surfaceContainer, child: Icon(Icons.error, color: Theme.of(context).colorScheme.error)),
                  ),
                ),
              ),
            if (!kIsWeb)
              // Mobile-specific background
              tag != null
                  ? FullscreenImageWrapper(
                      imgChild: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: !kIsWeb ? 52.0 : 550.0,
                        imageUrl: imgUrl,
                      ),
                      tag: tag!,
                      imgUrl: imgUrl,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: !kIsWeb ? 52.0 : 550.0,
                      imageUrl: imgUrl,
                    ),
            if (isCancelled)
              Container(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                child: Center(
                  child: Text(
                    'Cancelled',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
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
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.2), // Subdued color
            shape: BoxShape.circle, // Circular shape
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurFactor, sigmaY: blurFactor),
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimensions.spacingSmall),
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
