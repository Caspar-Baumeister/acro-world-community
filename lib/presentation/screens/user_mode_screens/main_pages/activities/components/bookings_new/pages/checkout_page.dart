import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_option_selection_provider.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/checkout_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage(this.classEvent, {super.key});

  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);
    final selectedBookingOption = ref.watch(selectedBookingOptionIdProvider);

    if (selectedBookingOption == null) {
      return const Center(child: Text("No booking option selected"));
    }

    final isDirectPayment =
        classEvent.classModel?.owner?.teacher?.stripeId != null;
    final isCashPayment = classEvent.classModel?.isCashAllowed ?? false;

    return Padding(
      padding: const EdgeInsets.all(AppPaddings.medium),
      child: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading user")),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("Please log in to continue."));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppPaddings.medium),
              Text(
                "Booking summary",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppPaddings.small),
              Container(
                padding: const EdgeInsets.all(AppPaddings.medium),
                decoration: BoxDecoration(
                  color: CustomColors.secondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _row("Class", classEvent.classModel?.name ?? ""),
                    _row("Date", _formattedDate(classEvent.startDateDT)),
                    _row("Ticket", selectedBookingOption.title ?? "—"),
                    _row(
                      "Price",
                      "${selectedBookingOption.realPriceDiscounted().toStringAsFixed(2)} ${selectedBookingOption.currency.symbol}",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppPaddings.large),
              Text(
                "Your information",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppPaddings.small),
              Container(
                padding: const EdgeInsets.all(AppPaddings.medium),
                decoration: BoxDecoration(
                  color: CustomColors.secondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _row("Name", user.name ?? "Not provided"),
                    _row("Email", user.email ?? "Not provided"),
                    _row("Acro level", user.level?.name ?? "Not specified"),
                    _row("Acro role", user.gender?.name ?? "Not specified"),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditUserdataPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Edit"),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (kIsWeb && isDirectPayment)
                StandartButton(
                  text: "Continue to payment",
                  isFilled: true,
                  width: double.infinity,
                  onPressed: () async {
                    final uri =
                        Uri.parse('https://example.com/booking/checkout.html');
                    if (!await launchUrl(uri)) {
                      throw 'Could not launch $uri';
                    }
                  },
                ),
              if (!kIsWeb && isDirectPayment)
                StandartButton(
                  text: "Pay with Stripe",
                  isFilled: true,
                  width: double.infinity,
                  onPressed: () {
                    // Handle Stripe payment
                    ref
                        .read(checkoutProvider.notifier)
                        .completeBooking(0, classEvent.id!);
                  },
                ),
              if (isCashPayment)
                StandartButton(
                  text: "Pay in Cash",
                  isFilled: true,
                  width: double.infinity,
                  onPressed: () {
                    // Handle cash payment
                    ref
                        .read(checkoutProvider.notifier)
                        .completeBooking(1, classEvent.id!);
                  },
                ),
              const SizedBox(height: AppPaddings.large),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String _formattedDate(DateTime date) {
    final weekday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final d = date;
    return "${weekday[d.weekday % 7]} ${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }
}
