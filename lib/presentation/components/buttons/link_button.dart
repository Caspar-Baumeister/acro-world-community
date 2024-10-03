// link_button_component.dart

import 'package:flutter/material.dart';

class LinkButtonComponent extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;

  const LinkButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: textColor ?? Theme.of(context).primaryColor,
                color: textColor ?? Theme.of(context).primaryColor,
              )),
    );
  }
}
