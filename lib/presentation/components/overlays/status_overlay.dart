import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class StatusOverlay extends StatelessWidget {
  final String status;
  final bool isCompact;

  const StatusOverlay({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : AppDimensions.spacingSmall,
        vertical: isCompact ? 2 : AppDimensions.spacingExtraSmall,
      ),
      decoration: BoxDecoration(
        // Slightly translucent to feel lighter over imagery
        color: statusInfo.color.withOpacity(0.92),
        borderRadius:
            BorderRadius.circular(isCompact ? 8 : AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: isCompact ? 0.5 : 0.8,
        ),
      ),
      child: Text(
        statusInfo.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isCompact ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return StatusInfo(color: Colors.green, text: "Confirmed");
      case "waitingforpayment":
        return StatusInfo(color: Colors.orange, text: "Waiting");
      case "pending":
        return StatusInfo(color: Colors.orange, text: "Pending");
      case "cancelled":
      case "canceled":
        return StatusInfo(color: Colors.red, text: "Cancelled");
      case "completed":
        return StatusInfo(color: Colors.blue, text: "Completed");
      default:
        return StatusInfo(color: Colors.grey, text: status);
    }
  }
}

class StatusInfo {
  final Color color;
  final String text;

  StatusInfo({required this.color, required this.text});
}
