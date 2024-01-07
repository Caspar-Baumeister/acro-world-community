import 'package:acroworld/utils/constants.dart';
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
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: percentage > appBarCollapsedThreshold
                ? Colors.black
                : Colors.white,
            onPressed: () => Navigator.pop(context),
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
