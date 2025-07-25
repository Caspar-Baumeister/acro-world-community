import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/booking_query_wrapper.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A standalone widget that encapsulates the bottom hover button logic
/// for the SingleClassPage, handling booking and calendar actions.
class SingleClassBottomHoverButton extends StatelessWidget {
  final ClassModel clas;
  final ClassEvent? classEvent;

  const SingleClassBottomHoverButton({
    super.key,
    required this.clas,
    this.classEvent,
  });

  @override
  Widget build(BuildContext context) {
    UserRoleProvider userRoleProvider =
        Provider.of<UserRoleProvider>(context, listen: false);
    // Determine if the class owner is billable (has stripeId)
    final billingTeacher =
        clas.owner?.teacher?.stripeId != null ? clas.owner : null;

    final isCashPayment = clas.isCashAllowed ?? false;

    // If there's an event with booking options and a billing teacher, show booking button
    if (classEvent != null &&
        classEvent!.classModel!.bookingOptions.isNotEmpty &&
        (billingTeacher != null || isCashPayment) &&
        !userRoleProvider.isCreator) {
      return BottomAppBar(
        elevation: 0,
        child: BookingQueryHoverButton(
          classEvent: classEvent!,
        ),
      );
    }

    // If there's an event but no booking options (creator view), hide the bar
    if (classEvent != null) {
      return const SizedBox.shrink();
    }

    // No specific event: show calendar modal button
    return BottomAppBar(
      elevation: 0,
      child: CustomBottomHoverButton(
        content: const Text(
          'Calendar',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        onPressed: () => buildMortal(
          context,
          CalenderModal(
            classId: clas.id!,
            isCreator: userRoleProvider.isCreator,
          ),
        ),
      ),
    );
  }
}
