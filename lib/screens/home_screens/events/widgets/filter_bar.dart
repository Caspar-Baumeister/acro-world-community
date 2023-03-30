import 'package:acroworld/components/standard_icon_button/standard_icon_button.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/event_filter_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget with PreferredSizeWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: StandardIconButton(
        text: eventFilterProvider.filterString(),
        icon: Icons.filter_list,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventFilterPage(),
            ),
          );
        },
        showClose: eventFilterProvider.isFilterActive(),
        onClose: () => eventFilterProvider.resetFilter(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
