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
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            color: widget.isChecked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: widget.isChecked
            ? Icon(
                Icons.check_rounded,
                size: widget.size,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : SizedBox(width: widget.size, height: widget.size),
      ),
    );
  }
}
