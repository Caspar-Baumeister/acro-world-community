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
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
