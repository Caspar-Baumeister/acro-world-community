import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.activeIdx,
    required this.changeIdx,
  });

  final int activeIdx;
  final Function changeIdx;

  @override
  BottomNavigationBar build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: activeIdx,
      onTap: (index) => changeIdx(index),
      selectedItemColor: CustomColors.primaryColor,
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            label: "Activities"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.festival_outlined,
            ),
            label: "Events"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
            ),
            label: "Teacher"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_3_outlined,
            ),
            label: "Profile"),
      ],
    );
  }
}
