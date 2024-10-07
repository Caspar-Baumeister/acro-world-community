import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/class_event_calender_query.dart';
import 'package:acroworld/presentation/shared_components/buttons/standart_button.dart';
import 'package:flutter/material.dart';

class CalenderModal extends StatelessWidget {
  const CalenderModal({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: CustomColors.primaryColor,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 12.0),
            Container(
                constraints: const BoxConstraints(minHeight: 300),
                child: ClassEventCalenderQuery(classId: classId)),
            const SizedBox(height: 20),
            StandardButton(
                text: "Close", onPressed: () => Navigator.of(context).pop()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
