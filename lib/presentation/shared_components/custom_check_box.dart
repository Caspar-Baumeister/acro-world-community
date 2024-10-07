import 'package:acroworld/core/utils/colors.dart';
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
            border: Border.all(color: Colors.grey),
            color: widget.isChecked ? CustomColors.primaryColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: widget.isChecked
            ? Icon(
                Icons.check_rounded,
                size: widget.size,
                color: Colors.white,
              )
            : SizedBox(width: widget.size, height: widget.size),
      ),
    );
  }
}
