import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class BookOptionComponent extends StatelessWidget {
  const BookOptionComponent(
      {super.key,
      required this.bookingOption,
      required this.onChanged,
      required this.value});

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
            activeColor: CustomColors.successTextColor,
            value: value,
            onChanged: (_) => onChanged(_),
          ),
        ),
        const SizedBox(width: AppPaddings.small),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingOption.title!,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                bookingOption.subtitle != null
                    ? Text(
                        bookingOption.subtitle!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    : Container()
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
                      bookingOption.originalPrice().toStringAsFixed(2) +
                          bookingOption.currency.symbol,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w200,
                          )),
                  Text(
                    bookingOption.realPriceDiscounted().toStringAsFixed(2) +
                        bookingOption.currency.symbol,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              )
            : Text(
                bookingOption.realPriceDiscounted().toStringAsFixed(2) +
                    bookingOption.currency.symbol,
                style: Theme.of(context).textTheme.titleLarge,
              ),
      ],
    );
  }
}
