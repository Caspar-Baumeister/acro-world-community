import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(
      {super.key,
      required this.onTap,
      required this.isChecked,
      this.size = 16});

  final VoidCallback onTap;
  final bool isChecked;
  final double size;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: widget.size + 4, // Add padding around the checkbox
        height: widget.size + 4,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isChecked
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.6),
            width: 2.0, // Thicker border for better visibility
          ),
          color: widget.isChecked ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          boxShadow: widget.isChecked
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.7),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: widget.isChecked
              ? Icon(
                  Icons.check_rounded,
                  size: widget.size - 2, // Slightly smaller icon to fit nicely
                  color: colorScheme.onPrimary,
                )
              : SizedBox(width: widget.size - 2, height: widget.size - 2),
        ),
      ),
    );
  }
}
