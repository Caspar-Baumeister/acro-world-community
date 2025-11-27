import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/regular_event_tab_view.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/single_occurence_tab_view.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class AddOrEditRecurringPatternPage extends StatefulWidget {
  const AddOrEditRecurringPatternPage(
      {super.key, this.recurringPattern, required this.onFinished});

  final RecurringPatternModel? recurringPattern;
  final Function(RecurringPatternModel recurringPattern) onFinished;

  @override
  State<AddOrEditRecurringPatternPage> createState() =>
      _AddOrEditRecurringPatternPageState();
}

class _AddOrEditRecurringPatternPageState
    extends State<AddOrEditRecurringPatternPage> {
  late RecurringPatternModel _recurringPattern;
  String? _errorMessage;

  void _editRecurringPattern(String key, dynamic value) {
    switch (key) {
      case "isRecurring":
        setState(() {
          _recurringPattern.isRecurring = value;
        });

        break;
      case "startDate":
        setState(() {
          _recurringPattern.startDate = value;
        });
        break;
      case "endDate":
        setState(() {
          _recurringPattern.endDate = value;
        });

        break;
      case "startTime":
        setState(() {
          _recurringPattern.startTime = value;
        });
        break;
      case "endTime":
        setState(() {
          _recurringPattern.endTime = value;
        });
        break;

      case "repeatEvery":
        setState(() {
          _recurringPattern.recurringEveryXWeeks = value;
        });
        break;

      case "dayOfWeek":
        setState(() {
          _recurringPattern.dayOfWeek = value;
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    if (widget.recurringPattern != null) {
      _recurringPattern = widget.recurringPattern!;
    } else {
      _recurringPattern = RecurringPatternModel(
        isRecurring: false,
        startDate: DateTime.now(),

        // startime is next full hour
        startTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 1,
          minute: 0,
        ),
        endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 2,
          minute: 0,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int initialIndex = _recurringPattern.isRecurring! ? 1 : 0;
    return BasePage(
      appBar: CustomAppbarSimple(
        title: widget.recurringPattern != null
            ? "Edit Occurence"
            : "Add Occurence",
      ),
      makeScrollable: false,
      child: Column(
        children: [
          Flexible(
            child: CustomTabView(
                onTap: (p0) => _editRecurringPattern("isRecurring", p0 == 1),
                initialIndex: initialIndex,
                tabTitles: const [
                  "Single Occurrencs",
                  "Regular Event"
                ],
                tabViews: [
                  SingleOccurenceTabView(
                      recurringPattern: _recurringPattern,
                      editRecurringPattern: _editRecurringPattern),
                  RegularEventTabView(
                      recurringPattern: _recurringPattern,
                      editRecurringPattern: _editRecurringPattern),
                ]),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingLarge,
              ).copyWith(
                  top: AppDimensions.spacingMedium,
                  bottom: AppDimensions.spacingMedium),
              child: Text(
                _errorMessage!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            )
          else
            const SizedBox(height: AppDimensions.spacingMedium),
          ModernButton(
              text: "Save",
              onPressed: () {
                _onNext();
              }),
        ],
      ),
    );
  }

  void _onNext() {
    setState(() {
      _errorMessage = null;
    });
    if (_recurringPattern.isRecurring == false &&
        _recurringPattern.endDate == null) {
      setState(() {
        _errorMessage = "End date is required for single occurence.";
      });
      return;
    }
    if (_recurringPattern.endDate != null &&
        _recurringPattern.startDate!.isAfter(_recurringPattern.endDate!)) {
      setState(() {
        _errorMessage = "End date cannot be before start date ";
      });
      return;
    }
    if (_recurringPattern.isRecurring == true) {
      if (_recurringPattern.dayOfWeek == null) {
        setState(() {
          _errorMessage = "Please select the day of the week.";
        });
        return;
      }
    }
    try {
      widget.onFinished(_recurringPattern);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
