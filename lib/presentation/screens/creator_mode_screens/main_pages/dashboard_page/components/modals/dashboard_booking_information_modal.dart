import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/commission_information_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/dashboard_single_booking_card.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class DashboardBookingInformationModal extends StatelessWidget {
  const DashboardBookingInformationModal(
      {super.key, required this.booking, required this.isClassBookingSummary});

  final ClassEventBooking booking;
  final bool isClassBookingSummary;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
        child: Column(
      children: [
        // detailed infirmation section
        SizedBox(
          height: BOOKING_CARD_HEIGHT,
          child: Row(
            children: [
              // image with round corners
              BookingCardImageSection(booking: booking),
              Expanded(
                child: BookingCardMainContentSection(booking: booking),
              ),
            ],
          ),
        ),
        // booking options section
        SizedBox(height: AppPaddings.small),
        Row(
          children: [
            Expanded(
              child: Text(
                  "Booking option: ${booking.bookingOption?.title} - ${booking.bookingPriceString}"),
            ),
            CommissionInformationButton(
              symbol:
                  booking.bookingOption?.currency.symbol ?? booking.currency,
              price: booking.amount,
            ),
          ],
        ),
        SizedBox(
          height: AppPaddings.medium,
        ),

        // User informations (gender and level)
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.inactiveBorderColor),
              borderRadius: AppBorders.smallRadius),
          padding: const EdgeInsets.all(AppPaddings.medium),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User informations",
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: AppPaddings.small),
                booking.user.gender?.name != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppPaddings.small),
                        child: Text(
                            "Prefered position: ${booking.user.gender?.name}"),
                      )
                    : SizedBox(),
                booking.user.level?.name != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppPaddings.small),
                        child: Text("Level: ${booking.user.level?.name}"),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),

        SizedBox(height: AppPaddings.large),

        // refund button
        LinkButtonComponent(
            text: "Refund ticket",
            textColor: CustomColors.errorBorderColor,
            onPressed: () {
              // TODO open stripe dashboard for now
            }),
        SizedBox(height: AppPaddings.medium),
        // report user button
        LinkButtonComponent(
            text: "Report user",
            textColor: CustomColors.errorBorderColor,
            onPressed: () {
              // TODO  write message to info@acroworld
            }),

        SizedBox(height: AppPaddings.medium),
        // see all bookings of this class event button
        if (!isClassBookingSummary)
          Padding(
            padding: const EdgeInsets.only(bottom: AppPaddings.medium),
            child: StandardButton(
                text: "Event bookings",
                isFilled: true,
                onPressed: () {
                  // navigate to bookings of class
                  if (booking.classEvent.id != null) {
                    Navigator.of(context).push(ClassBookingSummaryPageRoute(
                        classEventId: booking.classEvent.id!));
                  } else {
                    showErrorToast("Class event not found");
                  }
                }),
          ),

        StandardButton(
            text: "Back",
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    ));
  }
}
