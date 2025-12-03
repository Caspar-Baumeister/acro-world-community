import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

/// A small outlined button that opens a link when pressed
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.link,
    required this.text,
    this.icon,
    this.onPressed,
  });

  final String link;
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      icon: icon ?? Icons.open_in_new,
      isOutlined: true,
      isFilled: false,
      size: ButtonSize.small,
      onPressed: onPressed ?? () => customLaunch(link),
    );
  }
}

/// Backwards compatible alias - prefer using LinkButton directly
@Deprecated('Use LinkButton instead')
class SmallStandartButtonWithLink extends LinkButton {
  const SmallStandartButtonWithLink({
    super.key,
    required super.link,
    required super.text,
    Color? color,
    Function? customFunction,
  });
}
