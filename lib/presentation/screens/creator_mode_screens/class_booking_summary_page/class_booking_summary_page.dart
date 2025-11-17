import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/class_booking_summary_body.dart';
import 'package:flutter/material.dart';

class ClassBookingSummaryPage extends StatelessWidget {
  const ClassBookingSummaryPage({super.key, required this.classEventId});

  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const CustomAppbarSimple(
        title: "Bookings Summary",
      ),
      makeScrollable: true,
      child: ClassBookingSummaryBody(classEventId: classEventId),
    );
  }
}
