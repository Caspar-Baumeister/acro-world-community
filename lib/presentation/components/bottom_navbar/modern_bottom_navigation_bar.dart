import 'package:flutter/material.dart';

/// Modern bottom navigation bar with improved design and readability
class ModernBottomNavigationBar extends StatelessWidget {
  const ModernBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.additionalBottomPadding = 0,
  }) : assert(items.length >= 2 && items.length <= 5);

  final List<ModernNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final double additionalBottomPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: additionalBottomPadding + 12,
            top: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Expanded(
                child: _ModernNavigationItem(
                  item: item,
                  isSelected: selectedIndex == index,
                  isDisabled: item.disabled,
                  onTap: () => onItemSelected(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Modern navigation bar item with improved styling
class ModernNavigationBarItem {
  const ModernNavigationBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.disabled = false,
    this.badgeCount,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool disabled;
  final int? badgeCount;
}

class _ModernNavigationItem extends StatefulWidget {
  const _ModernNavigationItem({
    required this.item,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final ModernNavigationBarItem item;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  State<_ModernNavigationItem> createState() => _ModernNavigationItemState();
}

class _ModernNavigationItemState extends State<_ModernNavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconColor = widget.isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withOpacity(0.6);

    final labelColor = widget.isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withOpacity(0.6);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isDisabled ? null : _handleTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with background for selected state
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              widget.isSelected
                                  ? widget.item.selectedIcon
                                  : widget.item.icon,
                              color: iconColor,
                              size: 24,
                            ),
                            if ((widget.item.badgeCount ?? 0) > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (widget.item.badgeCount!).toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onError,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Label with better typography
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: labelColor,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 11,
                        ),
                        child: Text(
                          widget.item.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap() {
    if (!widget.isDisabled) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onTap();
    }
  }
}
