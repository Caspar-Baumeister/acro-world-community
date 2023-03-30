import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class StandardIconButton extends StatelessWidget {
  const StandardIconButton({
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.withBorder = true,
    this.width,
    this.showClose = false,
    this.onClose,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool withBorder;
  final double? width;
  final bool showClose;
  final Function? onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: withBorder ? Border.all(color: BUTTON_FILL_COLOR) : null,
          borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: withBorder ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 20),
            showClose
                ? GestureDetector(
                    onTap: () => onClose!(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                : Container(),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
