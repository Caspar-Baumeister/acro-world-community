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
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: additionalBottomPadding + 8,
          top: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Expanded(
              child: _NavigationItem(
                item: item,
                isSelected: selectedIndex == index,
                isDisabled: item.disabled,
                onTap: () => onItemSelected(index),
                iconDimension: 24,
              ),
            );
          }).toList(),
        ),
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
    this.iconDimension = 24,
  });

  final UiNavigationBarItem item;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;
  final double iconDimension;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool isPressed = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final iconColor = widget.isDisabled
        ? theme.unselectedItemColor?.withAlpha(100)
        : (widget.isSelected || isHovered
            ? theme.selectedItemColor
            : theme.unselectedItemColor);

    final labelStyle = (widget.isSelected
            ? theme.selectedLabelStyle
            : theme.unselectedLabelStyle) ??
        TextStyle(color: iconColor, fontSize: 12);

    return Semantics(
      container: true,
      selected: widget.isSelected,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.isDisabled
              ? null
              : () {
                  widget.onTap();
                  setState(() => isPressed = true);
                  Future.delayed(const Duration(milliseconds: 50), () {
                    setState(() => isPressed = false);
                  });
                },
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: isPressed ? 0.9 : 1,
                child: IconTheme(
                  data: IconThemeData(
                    color: iconColor,
                    size: widget.iconDimension,
                  ),
                  child: widget.item.icon,
                ),
              ),
              const SizedBox(height: 4),
              // Wrap title in Expanded to avoid wrapping on narrow layouts
              FittedBox(
                fit: BoxFit.scaleDown,
                child: DefaultTextStyle(
                  style: labelStyle.copyWith(
                    color: widget.isSelected
                        ? theme.selectedLabelStyle?.color
                        : theme.unselectedLabelStyle?.color,
                  ),
                  child: widget.item.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
