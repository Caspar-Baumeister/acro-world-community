import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/modals/stripe_highlight_modal.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class ClassOccurenceCard extends StatelessWidget {
  const ClassOccurenceCard({
    super.key,
    required this.classEvent,
    required this.onCancel,
    required this.onViewBookings,
  });

  final ClassEvent classEvent;
  final VoidCallback onCancel;
  final VoidCallback onViewBookings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (classEvent.isCancelled == false) {
          buildMortal(
              context,
              OccurenceCasrModal(
                  classEvent: classEvent,
                  onCancel: onCancel,
                  onViewBookings: onViewBookings));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium)
            .copyWith(top: AppPaddings.small),
        child: Container(
          decoration: BoxDecoration(
            color: CustomColors.backgroundColor,
            borderRadius: AppBorders.defaultRadius,
            border: classEvent.isHighlighted == true
                ? Border.all(color: CustomColors.successTextColor)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPaddings.medium, vertical: AppPaddings.small),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppPaddings.medium),
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 72,
                          child: Text(getDatedMM(classEvent.startDateDT),
                              style: Theme.of(context).textTheme.displayLarge),
                        ),
                      ),
                      classEvent.isHighlighted == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: AppPaddings.small),
                              child: const Text(
                                "Highlighted",
                                style: TextStyle(
                                    color: CustomColors.successTextColor),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getFormattedDateRange(
                              classEvent.startDateDT, classEvent.endDateDT,
                              isNewLine: true),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: AppPaddings.tiny),
                      classEvent.availableBookingSlots != null &&
                              classEvent.maxBookingSlots != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppPaddings.tiny),
                              child: showTextForBookingStatus(context))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                // if the event is not canceled, show the more icon
                if (classEvent.isCancelled == false)
                  Icon(
                    Icons.more_vert_outlined,
                    color: CustomColors.accentColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text showTextForBookingStatus(BuildContext context) {
    switch (classEvent.bookingStatus) {
      case ClassEventBookingStatus.canceled:
        return Text(
          "Canceled",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.errorTextColor),
        );
      case ClassEventBookingStatus.notEnabled:
        return Text(
          "Booking not enabled",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.errorTextColor),
        );
      case ClassEventBookingStatus.full:
        return Text(
          "Booked out",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.errorTextColor),
        );
      case ClassEventBookingStatus.empty:
        return Text(
          "No bookings yet",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.successTextColor),
        );
      case ClassEventBookingStatus.openSlots:
        return Text(
          "${classEvent.availableBookingSlots}/${classEvent.maxBookingSlots} slots available",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.successTextColor),
        );
      default:
        return const Text("");
    }
  }
}

// OccurenceCardModal (implements BaseModal)
class OccurenceCasrModal extends StatelessWidget {
  const OccurenceCasrModal(
      {super.key,
      required this.classEvent,
      required this.onCancel,
      required this.onViewBookings});

  final ClassEvent classEvent;
  final VoidCallback onCancel;
  final VoidCallback onViewBookings;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Column(
        children: [
          // Highlight the event
          classEvent.isHighlighted == true ||
                  classEvent.isCancelled == true ||
                  classEvent.startDateDT.isBefore(DateTime.now()) ||
                  classEvent.id == null
              ? const SizedBox.shrink()
              : ListTile(
                  title: const Text("Highlight Event"),
                  leading: const Icon(Icons.star_border),
                  onTap: () {
                    // Show modal
                    buildMortal(
                        context,
                        StripeHighlightModal(
                            classEventId: classEvent.id!,
                            startDate: classEvent.startDateDT));
                  },
                ),

          // View bookings
          classEvent.bookingStatus == ClassEventBookingStatus.empty ||
                  classEvent.bookingStatus ==
                      ClassEventBookingStatus.notEnabled ||
                  classEvent.bookingStatus == ClassEventBookingStatus.canceled
              ? const SizedBox.shrink()
              : ListTile(
                  title: const Text("View Bookings"),
                  leading: const Icon(Icons.calendar_view_month_sharp),
                  onTap: onViewBookings,
                ),

          // Cancel event
          classEvent.isCancelled == true ||
                  classEvent.startDateDT.isBefore(DateTime.now()) ||
                  classEvent.id == null
              ? const SizedBox.shrink()
              : ListTile(
                  title: const Text("Cancel Event"),
                  leading: const Icon(Icons.cancel),
                  onTap: onCancel,
                ),
        ],
      ),
    );
  }
}
