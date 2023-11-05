import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingInformationModal extends StatelessWidget {
  const BookingInformationModal(
      {Key? key, required this.classEvent, required this.bookingOption})
      : super(key: key);

  final ClassEvent classEvent;
  final BookingOption bookingOption;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ClassModel clas = classEvent.classModel!;

    num leftToPay = bookingOption.price! *
        (100 - (bookingOption.commission! + bookingOption.discount!)) *
        0.01;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: PRIMARY_COLOR,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 12.0),
            Text(
              "You have successfully reserved ${clas.name} on ${DateFormat('EEEE, H:mm').format(classEvent.startDateDT)}",
              style: H16W7,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              """Booking option: ${bookingOption.title}. 
We have sent a confirmation email with your name to the organizer.
You have to pay the remaining ${leftToPay.toStringAsFixed(2) + getCurrecySymbol(bookingOption.currency)} when you arrive.""",
              style: H14W4,
            ),
            const SizedBox(height: 20),
            StandartButton(
              text: "To the event",
              onPressed: () => classEvent.classModel != null
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SingleEventQueryWrapper(
                          classId: classEvent.classModel!.id!,
                          classEventId: classEvent.id,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
