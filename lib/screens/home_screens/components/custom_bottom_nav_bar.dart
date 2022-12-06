import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.activeIdx,
    required this.changeIdx,
  }) : super(key: key);

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
      selectedItemColor: PRIMARY_COLOR,
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            label: "Activities"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
            ),
            label: "Teacher"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.festival_outlined,
            ),
            label: "Events"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
            ),
            label: "Community"),
      ],
    );
  }
}
