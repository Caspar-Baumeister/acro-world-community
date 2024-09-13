import 'package:acroworld/components/appbar/base_appbar.dart';
import 'package:acroworld/components/buttons/place_button/place_button.dart';
import 'package:acroworld/routing/routes/page_routes/map_page_route.dart';
import 'package:flutter/material.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return BaseAppbar(
      title: Row(
        children: [
          const Expanded(
            child: PlaceButton(
              rightPadding: false,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MapPageRoute(),
            ),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
    );
  }
}
