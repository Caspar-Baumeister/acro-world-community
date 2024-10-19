import 'package:acroworld/presentation/components/bottom_navbar/base_bottom_navbar.dart';
import 'package:acroworld/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/creator_profile_page_route.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/icons/icon_library.dart';
import 'package:flutter/material.dart';

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
          Navigator.of(context).push(DashboardPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.calendar.icon,
        isSelected: selectedIndex == 1,
        label: 'My Events',
        onPressed: () {
          // navigate to club page
          Navigator.of(context).push(MyEventsPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.invites.icon,
        isSelected: selectedIndex == 2,
        label: 'Invites',
        onPressed: () {
          // open end drawer

          Navigator.of(context).push(InvitesPageRoute());
        },
      ),
      PrimaryBottomNavbarItem(
        icon: IconLibrary.profile.icon,
        isSelected: selectedIndex == 3,
        label: 'Creator Profile',
        onPressed: () {
          // open end drawer

          Navigator.of(context).push(CreatorProfilePageRoute());
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
