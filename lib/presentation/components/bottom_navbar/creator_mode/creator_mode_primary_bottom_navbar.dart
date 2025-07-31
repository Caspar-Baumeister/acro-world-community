import 'package:acroworld/presentation/components/bottom_navbar/base_bottom_navbar.dart';
import 'package:acroworld/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/icons/icon_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorModePrimaryBottomNavbar extends StatelessWidget {
  const CreatorModePrimaryBottomNavbar({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      PrimaryBottomNavbarItem(
        icon: IconLibrary.dashboard.icon,
        isSelected: selectedIndex == 0,
        label: 'Bookings',
        onPressed: () {
          // navigate to home page
          context.goNamed(creatorDashboardRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.calendar.icon,
        isSelected: selectedIndex == 1,
        label: 'My Events',
        onPressed: () {
          // navigate to club page
          context.goNamed(myEventsRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.invites.icon,
        isSelected: selectedIndex == 2,
        label: 'Invites',
        onPressed: () {
          // open end drawer

          context.goNamed(invitesRoute);
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.profile.icon,
        isSelected: selectedIndex == 3,
        label: 'Creator Profile',
        onPressed: () {
          // open end drawer

          context.goNamed(creatorProfileRoute);
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
