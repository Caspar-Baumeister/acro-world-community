import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/decorators.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class StandardIconButton extends StatelessWidget {
  const StandardIconButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.withBorder = true,
    this.width,
    this.showClose = false,
    this.onClose,
    this.loading = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool withBorder;
  final double? width;
  final bool showClose;
  final Function? onClose;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: inputButtonDecoration,
        height: INPUTFIELD_HEIGHT,
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(5),
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      )),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(text,
                        maxLines: withBorder ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: ACTIVE_INPUT_TEXT),
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
