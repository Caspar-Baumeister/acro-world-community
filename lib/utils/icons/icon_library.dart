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
        return Icons.event_available_rounded;
      case IconLibrary.profile:
        return Icons.person_rounded;
      case IconLibrary.community:
        return Icons.groups_rounded;
      case IconLibrary.dashboard:
        return Icons.dashboard_rounded;
      case IconLibrary.invites:
        return Icons.mail_rounded;
      case IconLibrary.world:
        return Icons.explore_rounded;
      default:
        throw Exception("Icon not found");
    }
  }
}
