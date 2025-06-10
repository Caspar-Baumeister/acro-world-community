import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/dashboard_single_booking_card.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DashboardBookingInformationModal extends StatelessWidget {
  const DashboardBookingInformationModal(
      {super.key, required this.booking, required this.isClassBookingSummary});

  final ClassEventBooking booking;
  final bool isClassBookingSummary;

  @override
  Widget build(BuildContext context) {
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    return BaseModal(
        child: Column(
      children: [
        // detailed infirmation section
        Row(
          children: [
            // image with round corners
            BookingCardImageSection(booking: booking),
            Expanded(
              child: BookingCardMainContentSection(booking: booking),
            ),
          ],
        ),
        // booking options section
        SizedBox(height: AppPaddings.small),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (booking.bookingOption?.bookingCategory?.name != null)
                    Text(
                        "Category: ${booking.bookingOption?.bookingCategory?.name}"),
                  Text(
                      "Booking option: ${booking.bookingOption?.title} - ${booking.bookingPriceString}"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppPaddings.medium,
        ),

        // User informations (gender and level)
        UserInformationWidget(booking: booking),
        SizedBox(height: AppPaddings.large),

        if (!isClassBookingSummary)
          Padding(
            padding: const EdgeInsets.only(bottom: AppPaddings.medium),
            child: StandartButton(
                text: "All bookings of this event",
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

        StandartButton(
            text: "Close",
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    ));
  }
}

class UserInformationWidget extends StatelessWidget {
  const UserInformationWidget({
    super.key,
    required this.booking,
  });

  final ClassEventBooking booking;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (booking.classEvent.id == null || booking.user.id == null) {
          showErrorToast("User or class event not found");
          return;
        }
        Navigator.of(context).push(UserAnswerPageRoute(
            classEventId: booking.classEvent.id!, userId: booking.user.id!));
      },
      child: Container(
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
                      padding: const EdgeInsets.only(bottom: AppPaddings.small),
                      child: Text(
                          "Prefered position: ${booking.user.gender?.name}"),
                    )
                  : SizedBox(),
              booking.user.level?.name != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: AppPaddings.small),
                      child: Text("Level: ${booking.user.level?.name}"),
                    )
                  : SizedBox(),
              booking.user.email != null
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            booking.user.email ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: booking.user.email ?? ""));
                              showInfoToast("Email copied");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: AppPaddings.small),
                              child: Icon(
                                Icons.copy,
                                size: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              CustomDivider(),
              Row(
                children: [
                  Text("View answers",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
