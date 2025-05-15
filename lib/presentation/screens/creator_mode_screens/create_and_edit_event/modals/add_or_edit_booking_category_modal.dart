import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddOrEditBookingCategoryModal extends StatefulWidget {
  const AddOrEditBookingCategoryModal(
      {super.key, required this.onFinished, this.bookingCategory});

  final Function onFinished;
  final BookingCategoryModel? bookingCategory;
  @override
  State<AddOrEditBookingCategoryModal> createState() =>
      _AddOrEditBookingCategoryModalState();
}

class _AddOrEditBookingCategoryModalState
    extends State<AddOrEditBookingCategoryModal> {
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _contingentController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _subTitleController = TextEditingController();
    _contingentController = TextEditingController();

    if (widget.bookingCategory != null) {
      _titleController.text = widget.bookingCategory!.name;
      _subTitleController.text = widget.bookingCategory!.description ?? "";
      _contingentController.text =
          widget.bookingCategory!.contingent.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _contingentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseModal(
        title:
            "${widget.bookingCategory == null ? "Add" : "Edit"} Ticket Category",
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
              labelText: 'Description',
            ),
            const SizedBox(height: AppPaddings.medium),
            InputFieldComponent(
              controller: _contingentController,
              labelText: 'Contingent',
              isNumberInput: true,
            ),
            const SizedBox(height: AppPaddings.toLarge),
            StandartButton(
              text: widget.bookingCategory == null ? "Create" : "Update",
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

    if (_contingentController.text.isEmpty) {
      setState(() {
        _errorMessage = "Contingent is required";
      });
      return;
    }

    print("Id existed and will be: ${widget.bookingCategory?.id}");

    widget.onFinished(BookingCategoryModel(
        id: widget.bookingCategory?.id ?? Uuid().v4(),
        name: _titleController.text,
        contingent: int.parse(_contingentController.text),
        description: _subTitleController.text));

    Navigator.of(context).pop();
  }
}
