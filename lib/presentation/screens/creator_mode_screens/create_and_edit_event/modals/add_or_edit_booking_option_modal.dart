import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/currency_formater.dart';
import 'package:flutter/material.dart';

class AddOrEditBookingOptionModal extends StatefulWidget {
  const AddOrEditBookingOptionModal(
      {super.key,
      required this.onFinished,
      this.bookingOption,
      required this.categoryID});

  final Function onFinished;
  final BookingOption? bookingOption;
  final String categoryID;

  @override
  State<AddOrEditBookingOptionModal> createState() =>
      _AddOrEditBookingOptionModalState();
}

class _AddOrEditBookingOptionModalState
    extends State<AddOrEditBookingOptionModal> {
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _priceController;
  CurrencyDetail? currentOption;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _subTitleController = TextEditingController();
    _priceController = TextEditingController();

    if (widget.bookingOption != null) {
      _titleController.text = widget.bookingOption!.title!;
      _subTitleController.text = widget.bookingOption!.subtitle ?? "";
      _priceController.text = widget.bookingOption!.price != null
          ? (widget.bookingOption!.price! / 100).toString()
          : "";
      currentOption = widget.bookingOption!.currency;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("currentOption: $currentOption");
    return BaseModal(
        title: "Create ticket for this event",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputFieldComponent(
              controller: _titleController,
              labelText: 'Title',
            ),
            const SizedBox(height: AppPaddings.medium),
            InputFieldComponent(
              controller: _subTitleController,
              labelText: 'Subtitle',
            ),
            const SizedBox(height: AppPaddings.medium),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: InputFieldComponent(
                    controller: _priceController,
                    labelText: 'Price',
                    isNumberInput: true,
                  ),
                ),
                const SizedBox(width: AppPaddings.medium),
                Flexible(
                  flex: 1,
                  child: CustomOptionInputComponent(
                    currentOption: currentOption?.value == null &&
                            currentOption?.label == null
                        ? null
                        : OptionObjects(
                            currentOption!.value,
                            currentOption!.label,
                          ),
                    options: OptionObjects.getOptionsFromTwoLists(
                        CurrencyDetail.getCurrencyDetails()
                            .map(
                              (e) => e.value,
                            )
                            .toList(),
                        CurrencyDetail.getCurrencyDetails()
                            .map(
                              (e) => e.label,
                            )
                            .toList()),
                    onOptionSet: (value) {
                      setState(() {
                        currentOption = CurrencyDetail.getCurrencyDetail(value);
                      });
                    },
                    hintText: "Currency",
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppPaddings.toLarge),
            StandardButton(
              text: widget.bookingOption == null ? "Create" : "Update",
              onPressed: () {
                _onNext();
              },
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: AppPaddings.medium),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: CustomColors.errorTextColor),
                ),
              ),
          ],
        ));
  }

  // on next button click
  void _onNext() {
    if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = "Title is required";
      });
      return;
    }

    if (_priceController.text.isEmpty) {
      setState(() {
        _errorMessage = "Price is required";
      });
      return;
    }
    if (currentOption == null) {
      setState(() {
        _errorMessage = "Currency is required";
      });
      return;
    }

    widget.onFinished(BookingOption(
        title: _titleController.text,
        price: 100 * double.parse(_priceController.text),
        currency: currentOption!,
        bookingCategoryId: widget.categoryID,
        subtitle: _subTitleController.text));

    Navigator.of(context).pop();
  }
}
