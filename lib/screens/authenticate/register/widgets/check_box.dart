import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  const CheckBox(
      {Key? key, required this.onTap, required this.isChecked, this.size = 16})
      : super(key: key);

  final VoidCallback onTap;
  final bool isChecked;
  final double size;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: widget.isChecked ? PRIMARY_COLOR : Colors.white,
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
