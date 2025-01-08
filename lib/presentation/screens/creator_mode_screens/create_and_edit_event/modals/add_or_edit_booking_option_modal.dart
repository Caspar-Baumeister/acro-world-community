import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/currency_formater.dart';
import 'package:flutter/material.dart';

/// Modal to create or edit a BookingOption
/// Contains fields for title, subtitle, price, and currency
class AddOrEditBookingOptionModal extends StatefulWidget {
  const AddOrEditBookingOptionModal({
    super.key,
    required this.onFinished,
    this.bookingOption,
    required this.categoryID,
  });

  /// Callback to call when the booking option is created or updated
  final Function onFinished;

  /// (Optional) Existing booking option to edit
  final BookingOption? bookingOption;

  /// ID of the category to which this booking option belongs
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

    // If an existing bookingOption is provided, populate the controllers
    if (widget.bookingOption != null) {
      _titleController.text = widget.bookingOption!.title ?? "";
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
    return BaseModal(
      title: "Create ticket for this event",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title input
          InputFieldComponent(
            controller: _titleController,
            labelText: 'Title',
          ),
          const SizedBox(height: AppPaddings.medium),

          // Subtitle input
          InputFieldComponent(
            controller: _subTitleController,
            labelText: 'Subtitle',
          ),
          const SizedBox(height: AppPaddings.medium),

          // Price and currency inputs
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
                  currentOption: (currentOption?.value == null &&
                          currentOption?.label == null)
                      ? null
                      : OptionObjects(
                          currentOption!.value,
                          currentOption!.label,
                        ),
                  options: OptionObjects.getOptionsFromTwoLists(
                    CurrencyDetail.getCurrencyDetails()
                        .map((e) => e.value)
                        .toList(),
                    CurrencyDetail.getCurrencyDetails()
                        .map((e) => e.label)
                        .toList(),
                  ),
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

          // Create/Update button
          StandardButton(
            text: widget.bookingOption == null ? "Create" : "Update",
            onPressed: _onNext,
          ),

          // Optional error message
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
      ),
    );
  }

  /// Validate and call `onFinished` with the new or updated booking option.
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

    // Construct or update the BookingOption object
    final newOption = BookingOption(
      title: _titleController.text,
      subtitle: _subTitleController.text,
      price: 100 * double.parse(_priceController.text), // Convert to cents
      currency: currentOption!,
      bookingCategoryId: widget.categoryID,
    );

    // Call the callback to finish
    widget.onFinished(newOption);
    Navigator.of(context).pop();
  }
}
