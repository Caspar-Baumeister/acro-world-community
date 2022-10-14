import 'package:flutter/material.dart';

class StandardIconButton extends StatelessWidget {
  const StandardIconButton({
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.withBorder = true,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          // Supply null for displaying default border
          side: withBorder ? null : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
