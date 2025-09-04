import 'package:flutter/material.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';

/// A modern user card component for the community page
class ModernUserCard extends StatelessWidget {
  const ModernUserCard({
    super.key,
    required this.name,
    required this.followerCount,
    required this.profileImageUrl,
    required this.isFollowed,
    required this.onFollowTap,
    required this.onCardTap,
    this.isLoading = false,
    this.description,
  });

  final String name;
  final int followerCount;
  final String profileImageUrl;
  final bool isFollowed;
  final VoidCallback onFollowTap;
  final VoidCallback onCardTap;
  final bool isLoading;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCardTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomCachedNetworkImage(
                      imageUrl: profileImageUrl,
                      width: 56,
                      height: 56,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatFollowerCount(followerCount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Follow Button
                _ModernFollowButton(
                  isFollowed: isFollowed,
                  isLoading: isLoading,
                  onTap: onFollowTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M followers';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K followers';
    } else {
      return '$count followers';
    }
  }
}

/// A modern follow button component
class _ModernFollowButton extends StatefulWidget {
  const _ModernFollowButton({
    required this.isFollowed,
    required this.isLoading,
    required this.onTap,
  });

  final bool isFollowed;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<_ModernFollowButton> createState() => _ModernFollowButtonState();
}

class _ModernFollowButtonState extends State<_ModernFollowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: widget.isFollowed
                    ? colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isFollowed
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isFollowed
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      widget.isFollowed ? 'Followed' : 'Follow',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.isFollowed
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
