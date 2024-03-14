import 'package:flutter/material.dart';

enum IconLibrary {
  history,
  logOut,
  shares,
  coupon,
  plus,
  minus,
  home,
  star,
  bell,
  support,
  settings,
  copy,
  share,
  legal,
  play,
  megaphone,
  arrowEast,
  arrowWest,

  discover,
  calendar,
  profile,
  community,
  bird,
}

// extension for the assetName

extension ImageAssetNameExtension on IconLibrary {
  String get assetName {
    switch (this) {
      case IconLibrary.bird:
        return "assets/icons/dove-solid.svg";
      case IconLibrary.history:
        return "assets/icons/history.png";
      case IconLibrary.logOut:
        return "assets/icons/log_out.png";
      case IconLibrary.shares:
        return "assets/icons/shares.png";
      case IconLibrary.coupon:
        return "assets/icons/coupon.png";
      case IconLibrary.plus:
        return "assets/icons/plus.png";
      case IconLibrary.minus:
        return "assets/icons/minus.png";
      case IconLibrary.home:
        return "assets/icons/home.png";
      case IconLibrary.star:
        return "assets/icons/star.png";
      case IconLibrary.bell:
        return "assets/icons/bell.png";
      case IconLibrary.support:
        return "assets/icons/support.png";
      case IconLibrary.settings:
        return "assets/icons/settings.png";
      case IconLibrary.copy:
        return "assets/icons/copy.png";
      case IconLibrary.share:
        return "assets/icons/share.png";
      case IconLibrary.legal:
        return "assets/icons/legal.png";
      case IconLibrary.play:
        return "assets/icons/play.png";
      case IconLibrary.megaphone:
        return "assets/icons/megaphone.png";
      case IconLibrary.arrowEast:
        return "assets/icons/arrow_east.png";
      case IconLibrary.arrowWest:
        return "assets/icons/arrow_west.png";

      default:
        throw Exception("Icon not found");
    }
  }
}

extension ImageIconExtension on IconLibrary {
  AssetImage get imageIcon {
    switch (this) {
      case IconLibrary.bird:
        return const AssetImage("assets/icons/dove-solid.png");
      case IconLibrary.history:
        return const AssetImage("assets/icons/history.png");
      case IconLibrary.logOut:
        return const AssetImage("assets/icons/log_out.png");
      case IconLibrary.shares:
        return const AssetImage("assets/icons/shares.png");
      case IconLibrary.coupon:
        return const AssetImage("assets/icons/coupon.png");
      case IconLibrary.plus:
        return const AssetImage("assets/icons/plus.png");
      case IconLibrary.minus:
        return const AssetImage("assets/icons/minus.png");
      case IconLibrary.home:
        return const AssetImage("assets/icons/home.png");
      case IconLibrary.star:
        return const AssetImage("assets/icons/star.png");
      case IconLibrary.bell:
        return const AssetImage("assets/icons/bell.png");
      case IconLibrary.support:
        return const AssetImage("assets/icons/support.png");
      case IconLibrary.settings:
        return const AssetImage("assets/icons/settings.png");
      case IconLibrary.copy:
        return const AssetImage("assets/icons/copy.png");
      case IconLibrary.share:
        return const AssetImage("assets/icons/share.png");
      case IconLibrary.legal:
        return const AssetImage("assets/icons/legal.png");
      case IconLibrary.play:
        return const AssetImage("assets/icons/play.png");
      case IconLibrary.megaphone:
        return const AssetImage("assets/icons/megaphone.png");
      case IconLibrary.arrowEast:
        return const AssetImage("assets/icons/arrow_east.png");
      case IconLibrary.arrowWest:
        return const AssetImage("assets/icons/arrow_west.png");

      default:
        throw Exception("Icon not found");
    }
  }
}

extension IconDataExtension on IconLibrary {
  IconData get icon {
    switch (this) {
      case IconLibrary.history:
        return Icons.history;
      case IconLibrary.logOut:
        return Icons.logout;
      case IconLibrary.shares:
        return Icons.share;
      case IconLibrary.coupon:
        return Icons.local_offer;
      case IconLibrary.plus:
        return Icons.add;
      case IconLibrary.minus:
        return Icons.remove;
      case IconLibrary.home:
        return Icons.home;
      case IconLibrary.star:
        return Icons.star;
      case IconLibrary.bell:
        return Icons.notifications;
      case IconLibrary.support:
        return Icons.support;
      case IconLibrary.settings:
        return Icons.settings;
      case IconLibrary.copy:
        return Icons.copy;
      case IconLibrary.share:
        return Icons.share;
      case IconLibrary.legal:
        return Icons.gavel;
      case IconLibrary.play:
        return Icons.play_arrow;

      case IconLibrary.arrowEast:
        return Icons.arrow_forward;
      case IconLibrary.arrowWest:
        return Icons.arrow_back;
      case IconLibrary.discover:
        return Icons.search;
      case IconLibrary.calendar:
        return Icons.calendar_month_outlined;
      case IconLibrary.profile:
        return Icons.person;
      case IconLibrary.community:
        return Icons.people;

      default:
        throw Exception("Icon not found");
    }
  }
}
