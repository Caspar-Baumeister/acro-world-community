import 'dart:ui';

import 'package:acroworld/core/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.actions,
    required ValueNotifier<double> percentageCollapsed,
    required this.headerText,
    required this.imgUrl,
  }) : _percentageCollapsed = percentageCollapsed;

  final List<Widget> actions;
  final ValueNotifier<double> _percentageCollapsed;
  final String headerText;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
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
      expandedHeight: appBarExpandedHeight,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
        ],
        // title: Text(clas.name ?? "",
        //     maxLines: 3, style: HEADER_1_TEXT_STYLE),
        background: CachedNetworkImage(
          fit: BoxFit.cover,
          height: 52.0,
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
          imageUrl: imgUrl,
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
        onTap: () => Navigator.pop(context),
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
