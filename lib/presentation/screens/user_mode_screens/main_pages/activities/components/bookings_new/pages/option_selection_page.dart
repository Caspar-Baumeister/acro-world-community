import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_option_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingOptionSelectionPage extends ConsumerWidget {
  final ClassEvent event;

  const BookingOptionSelectionPage(this.event, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final className = event.classModel?.name ?? 'Unnamed';
    final ownerName = event.classModel?.owner?.teacher?.name ?? 'Unknown';
    final date = event.startDateDT;
    final categories = event.classModel?.bookingCategories ?? [];

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          _eventHeader(className, ownerName, date),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final category = categories[i];
                return _categoryBlock(context, ref, category);
              },
            ),
          ),
          _continueButton(ref, event),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _eventHeader(String name, String owner, DateTime date) => Column(
        children: [
          const SizedBox(height: 12),
          Text(name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("by $owner", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 2),
          Text(_formatDate(date), style: const TextStyle(color: Colors.grey)),
          Text("09:30 AM - 05:45 AM",
              style: const TextStyle(color: Colors.grey)),
        ],
      );

  Widget _categoryBlock(
      BuildContext context, WidgetRef ref, BookingCategoryModel category) {
    final bookingOption = ref.watch(selectedBookingOptionIdProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("Available tickets: ${category.contingent}/10"),
        const SizedBox(height: 8),
        ...category.bookingOptions!.map(
          (option) => _optionCard(option, bookingOption?.id, () {
            ref.read(selectedBookingOptionIdProvider.notifier).state = option;
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _optionCard(
      BookingOption option, String? selectedId, VoidCallback onTap) {
    final selected = option.id == selectedId;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: selected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (option.subtitle != null)
                    Text(option.subtitle!,
                        style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text("${(option.originalPrice()).toStringAsFixed(2)} €",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.green[700] : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _continueButton(WidgetRef ref, ClassEvent event) {
    final selected = ref.watch(selectedBookingOptionIdProvider);
    final total = event.availableBookingSlots ?? 0;
    final max = event.maxBookingSlots ?? 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: selected == null
                ? null
                : () {
                    // TODO: Proceed to next step
                  },
            child: const Text("Continue", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 8),
        Text("$total / $max places left",
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${_weekday(date.weekday)} ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  String _weekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday % 7];
  }
}
