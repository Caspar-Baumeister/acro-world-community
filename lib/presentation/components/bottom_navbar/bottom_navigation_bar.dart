import 'package:flutter/material.dart';

class BBottomNavigationBar extends StatelessWidget {
  const BBottomNavigationBar({
    required this.items,
    super.key,
    this.selectedIndex = 0,
    this.additionalBottomPadding = 0,
    required this.onItemSelected,
  }) : assert(items.length >= 2 && items.length <= 5);

  final List<UiNavigationBarItem> items;
  final int selectedIndex;
  final double additionalBottomPadding;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var index = items.indexOf(item);
          return _NavigationItem(
            item: item,
            dimension: 52,
            isSelected: selectedIndex == index,
            isDisabled: item.disabled,
            onTap: () {
              onItemSelected(index);
            },
          );
        }).toList(),
      ),
    );
  }
}

class UiNavigationBarItem {
  const UiNavigationBarItem({
    required this.icon,
    required this.title,
    this.disabled = false,
  });

  final Widget icon;
  final Widget title;
  final bool disabled;
}

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
    this.dimension = 50,
  });

  final UiNavigationBarItem item;
  final bool isSelected;
  final bool isDisabled;
  final void Function() onTap;
  final double dimension;
  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool isPressed = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color? iconColor;
    if (widget.isSelected || isHovered) {
      iconColor = Theme.of(context).bottomNavigationBarTheme.selectedItemColor;
    } else if (widget.isDisabled) {
      iconColor = Theme.of(context)
          .bottomNavigationBarTheme
          .unselectedItemColor
          ?.withAlpha(100);
    } else {
      iconColor =
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    }

    return Semantics(
      container: true,
      selected: widget.isSelected,
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!widget.isDisabled) widget.onTap();

            setState(() {
              isPressed = true;
            });
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                isPressed = false;
              });
            });
          },
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: widget.dimension,
            height: widget.dimension,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 100),
              //padding: EdgeInsets.all(10),
              scale: isPressed ? 0.9 : 1,
              child: AnimatedTheme(
                data: ThemeData(
                  iconTheme: IconThemeData(
                    color: iconColor,
                  ),
                ),
                child: FittedBox(
                  child: widget.item.icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
