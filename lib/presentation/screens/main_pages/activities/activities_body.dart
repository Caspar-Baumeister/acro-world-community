import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/presentation/screens/main_pages/activities/components/calendar_component.dart';
import 'package:acroworld/presentation/screens/main_pages/activities/components/class_components/classes_view.dart';
import 'package:flutter/material.dart';

class ActivitiesBody extends StatelessWidget {
  const ActivitiesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Calendar component
        CalendarComponent(),
        Divider(color: CustomColors.primaryColor),
        // Classes listed in a list view for selected day day
        Expanded(
          child: ClassesView(),
        )
      ],
    );
  }
}
