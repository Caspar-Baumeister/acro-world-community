import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/core/utils/icons/icon_library.dart';
import 'package:acroworld/presentation/shared_components/bottom_navbar/base_bottom_navbar.dart';
import 'package:acroworld/presentation/shared_components/bottom_navbar/primary_bottom_navbar_item.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes_user/calendar_page_route.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes_user/community_page_route.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes_user/discover_page_route.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes_user/profile_page_route.dart';
import 'package:flutter/material.dart';

class PrimaryBottomNavbar extends StatelessWidget {
  const PrimaryBottomNavbar({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      PrimaryBottomNavbarItem(
        imageIcon: IconLibrary.world.imageIcon,
        isSelected: selectedIndex == 0,
        label: 'Events',
        onPressed: () {
          // navigate to home page
          Navigator.of(context).push(DiscoverPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.calendar.icon,
        isSelected: selectedIndex == 1,
        label: 'Around me',
        onPressed: () {
          // navigate to club page
          Navigator.of(context).push(CalendarPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.community.icon,
        isSelected: selectedIndex == 2,
        label: 'Community',
        onPressed: () {
          // open end drawer

          Navigator.of(context).push(CommunityPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.profile.icon,
        isSelected: selectedIndex == 3,
        label: 'Profile',
        onPressed: () {
          // open end drawer

          Navigator.of(context).push(ProfilePageRoute());
        },
      ),
    ];
    return BaseBottomNavigationBar(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    ));
  }
}
