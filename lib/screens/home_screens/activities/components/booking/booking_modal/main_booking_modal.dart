import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingModal extends StatefulWidget {
  const BookingModal(
      {Key? key,
      required this.classEvent,
      required this.placesLeft,
      required this.refetch})
      : super(key: key);

  final ClassEvent classEvent;
  final num placesLeft;
  final void Function()? refetch;

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  late String? currentOption;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    currentOption =
        widget.classEvent.classModel?.classBookingOptions?[0].bookingOption?.id;
  }

  // set current option to the selected option
  void setCurrentOption(String value) {
    setState(() {
      currentOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;
    ClassModel clas = widget.classEvent.classModel!;

    BookingOption? currentOptionObject;
    if (currentOption != null) {
      currentOptionObject = clas.classBookingOptions!
          .firstWhere((e) => e.bookingOption?.id == currentOption)
          .bookingOption!;
    }

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
            Column(
              children: [
                Text(
                  "Booking options for ${clas.name} on ${DateFormat('EEEE, H:mm').format(widget.classEvent.date)}",
                  style: H16W7,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Column(children: [
                  ...clas.classBookingOptions!
                      .map((e) => Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(right: 20),
                            child: BookOption(
                              bookingOption: e.bookingOption!,
                              value: currentOption == e.bookingOption!.id!,
                              onChanged: (_) {
                                setCurrentOption(e.bookingOption!.id!);
                              },
                            ),
                          ))
                      .toList(),
                ]),
                const SizedBox(height: 20),
                StandartButton(
                  text: "Continue",
                  onPressed: () {
                    // close this modal and open the payment modal
                    // Navigator.of(context).pop();
                    // buildMortal(
                    //     context,
                    //     CheckoutModal(
                    //       classEvent: widget.classEvent,
                    //       bookingOption: currentOptionObject!,
                    //     ));
                  },
                ),
                Text(
                  "${widget.placesLeft} places left",
                  style: H10W4,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
