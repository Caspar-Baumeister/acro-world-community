import 'package:acroworld/presentation/components/bottom_navbar/base_bottom_navbar.dart';
import 'package:acroworld/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/icons/icon_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          context.goNamed(discoverRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.calendar.icon,
        isSelected: selectedIndex == 1,
        label: 'Around me',
        onPressed: () {
          // navigate to club page
          context.goNamed(activitiesRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.community.icon,
        isSelected: selectedIndex == 2,
        label: 'Community',
        onPressed: () {
          // open end drawer

          context.goNamed(communityRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.profile.icon,
        isSelected: selectedIndex == 3,
        label: 'Profile',
        onPressed: () {
          // open end drawer

          context.goNamed(profileRoute);
        },
      ),
    ];
    return BaseBottomNavigationBar(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    ));
  }
}
