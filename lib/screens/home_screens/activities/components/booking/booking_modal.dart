import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/webviews/book_class_webview.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
            Text(
              "Reserve a place for ${clas.name} on ${DateFormat('EEEE, H:mm').format(widget.classEvent.date)}",
              style: H16W7,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Column(children: [
              ...clas.classBookingOptions!
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(right: 20),
                        child: BookOption(
                          bookingOption: e.bookingOption!,
                          value: currentOption == e.bookingOption!.id!,
                          onChanged: (_) {
                            setState(() {
                              currentOption = e.bookingOption!.id!;
                            });
                          },
                        ),
                      ))
                  .toList(),
            ]),
            const SizedBox(height: 20),
            Text(
              "A non-refundable deposit ${currentOptionObject != null ? ("of ${currentOptionObject.deposit().toStringAsFixed(2)}${getCurrecySymbol(currentOptionObject.currency)}") : ""} will be required to confirm your reservation. The remaining balance ${currentOptionObject != null ? ("of ${currentOptionObject.toPayOnArrival().toStringAsFixed(2)}${getCurrecySymbol(currentOptionObject.currency)}") : ""} will be charged upon your arrival or as determined by the establishment. Please note that the deposit amount cannot be refunded in case of cancellation.",
              style: H12W4,
            ),
            const SizedBox(height: 20),
            StandardIconButton(
              text: "Pay deposit",
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                print(
                    "https://${AppEnvironment.backendHost}/api/payment/?bookingOptionId=${currentOptionObject!.id}&?classEventId=${widget.classEvent.id}&?userId=${userProvider.activeUser!.id}");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookClassWebView(
                        initialUrl:
                            "https://${AppEnvironment.backendHost}/api/payment/?bookingOptionId=${currentOptionObject!.id}&?classEventId=${widget.classEvent.id}&?userId=${userProvider.activeUser!.id}",
                        onFinish: () {
                          Fluttertoast.showToast(
                              msg:
                                  "Order completed, we have send an email with your name to the astablishment",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          widget.refetch!();
                          Navigator.of(context).pop();
                        }),
                  ),
                );
                setState(() {
                  loading = false;
                });
              },
              icon: Icons.paypal,
            ),
            Text(
              "${widget.placesLeft} places left",
              style: H10W4,
            )
          ],
        ),
      ),
    );
  }
}

class BookOption extends StatelessWidget {
  const BookOption(
      {Key? key,
      required this.bookingOption,
      required this.onChanged,
      required this.value})
      : super(key: key);

  final Function(bool?) onChanged;
  final bool value;
  final BookingOption bookingOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            activeColor: SUCCESS_COLOR,
            value: value,
            onChanged: (_) => onChanged(_),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingOption.title!,
                  style: H16W7,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  bookingOption.subtitle!,
                  style: H14W4,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        bookingOption.discount != 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      bookingOption.price!.toStringAsFixed(2) +
                          getCurrecySymbol(bookingOption.currency),
                      style: H16W7.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w200,
                      )),
                  Text(
                    bookingOption.realPrice().toStringAsFixed(2) +
                        getCurrecySymbol(bookingOption.currency),
                    style: H16W7,
                  ),
                ],
              )
            : Text(
                bookingOption.realPrice().toStringAsFixed(2) +
                    getCurrecySymbol(bookingOption.currency),
                style: H16W7,
              ),
      ],
    );
  }
}
