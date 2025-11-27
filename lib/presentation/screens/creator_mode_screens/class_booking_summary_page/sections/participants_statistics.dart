import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/components/model_pie_chart.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class ParticipantsStatistics extends StatelessWidget {
  const ParticipantsStatistics({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    final userGenders = bookings
        .where((element) => element.user.gender?.name != null)
        .map((booking) => booking.user.gender!.name!)
        .toList();

    final userLevels = bookings
        .where((element) => element.user.level?.name != null)
        .map((booking) => booking.user.level!.name!)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingSmall),
      child: Row(
        children: [
          Flexible(child: ModelPieChart(modelNames: userGenders)),
          Flexible(child: ModelPieChart(modelNames: userLevels)),
        ],
      ),
    );
  }
}
