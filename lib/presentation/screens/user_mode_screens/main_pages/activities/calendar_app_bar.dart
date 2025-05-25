import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/components/buttons/place_button/place_button.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            onPressed: () => context.pushNamed(
              mapRoute,
            ),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
    );
  }
}
