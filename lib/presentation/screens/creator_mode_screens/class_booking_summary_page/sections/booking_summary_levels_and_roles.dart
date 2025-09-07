import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BookingSummaryLevelsAndRoles extends StatelessWidget {
  const BookingSummaryLevelsAndRoles({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate level data
    final levelData = _calculateLevelData();
    final roleData = _calculateRoleData();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level section
          _buildSection(
            context,
            "Level",
            levelData,
            Icons.trending_up,
            colorScheme.primary,
          ),
          const SizedBox(height: 16),
          // Role section
          _buildSection(
            context,
            "Role",
            roleData,
            Icons.person,
            colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Map<String, int> data,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: data.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.key,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.value.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Calculate level data
  Map<String, int> _calculateLevelData() {
    final Map<String, int> dataMap = {};
    
    for (var booking in bookings) {
      String levelName = "Not Specified";
      
      if (booking.user.level?.name != null) {
        levelName = booking.user.level!.name!;
      }
      
      dataMap[levelName] = (dataMap[levelName] ?? 0) + 1;
    }
    
    return dataMap;
  }

  /// Calculate role data (gender/acro role)
  Map<String, int> _calculateRoleData() {
    final Map<String, int> dataMap = {};
    
    for (var booking in bookings) {
      String roleName = "Not Specified";
      
      if (booking.user.gender?.name != null) {
        roleName = booking.user.gender!.name!;
      }
      
      dataMap[roleName] = (dataMap[roleName] ?? 0) + 1;
    }
    
    return dataMap;
  }
}
