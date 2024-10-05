import 'package:flutter/material.dart';

enum IconLibrary {
  calendar,
  profile,
  community,
  world,
  invites,
  dashboard,
}

extension ImageIconExtension on IconLibrary {
  AssetImage get imageIcon {
    switch (this) {
      case IconLibrary.world:
        return const AssetImage("assets/icons/earth_location.png");
      default:
        throw Exception("Icon not found");
    }
  }
}

extension IconDataExtension on IconLibrary {
  IconData get icon {
    switch (this) {
      case IconLibrary.calendar:
        return Icons.calendar_month_outlined;
      case IconLibrary.profile:
        return Icons.person;
      case IconLibrary.community:
        return Icons.people;
      case IconLibrary.dashboard:
        return Icons.dashboard;
      case IconLibrary.invites:
        return Icons.mail;
      default:
        throw Exception("Icon not found");
    }
  }
}
