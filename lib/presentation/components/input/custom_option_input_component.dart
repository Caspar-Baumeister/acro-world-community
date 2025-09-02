import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CustomOptionInputComponent extends StatelessWidget {
  const CustomOptionInputComponent({
    super.key,
    required this.currentOption,
    required this.onOptionSet,
    required this.options,
    required this.hintText,
    this.footnoteText,
  });

  final OptionObjects? currentOption;
  final Function(String) onOptionSet;
  final List<OptionObjects> options;
  final String hintText;
  final String? footnoteText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMedium)
                .copyWith(bottom: AppDimensions.spacingExtraSmall),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          child: SizedBox(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentOption?.value,
                isExpanded: true,
                hint: Text(hintText),
                onChanged: (String? newValue) {
                  onOptionSet(newValue!);
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      hintText,
                      style: const TextStyle(
                          color: Colors.grey), // Placeholder text color
                    ),
                  ),
                  ...options
                      .map<DropdownMenuItem<String>>((OptionObjects object) {
                    return DropdownMenuItem<String>(
                      value: object.value,
                      child: Text(options
                          .firstWhere(
                              (element) => element.value == object.value)
                          .displayValue),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        footnoteText != null
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Text(footnoteText!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

class OptionObjects {
  final String value;
  final String displayValue;

  OptionObjects(this.value, this.displayValue);

  static List<OptionObjects> getOptionsUniqueStringList(List<String> options) {
    final List<OptionObjects> optionObjects = [];
    for (final String option in options) {
      optionObjects.add(OptionObjects(option, option));
    }
    return optionObjects;
  }

  static List<OptionObjects> getOptionsFromTwoLists(
      List<String> options, List<String> displayOptions) {
    final List<OptionObjects> optionObjects = [];
    for (int i = 0; i < options.length; i++) {
      optionObjects.add(OptionObjects(options[i], displayOptions[i]));
    }
    return optionObjects;
  }
}

class CustomQueryOptionInputComponent extends StatelessWidget {
  const CustomQueryOptionInputComponent(
      {super.key,
      required this.query,
      required this.identifier,
      required this.currentOption,
      required this.setOption,
      this.footnoteText,
      required this.valueIdentifier,
      this.hintText = "Choose a value",
      this.beatifyValueFunction}); // Default hint text

  final String? footnoteText;
  final QueryOptions query;
  final String identifier;
  final String? currentOption;
  final Function(String? value) setOption;
  final String valueIdentifier;
  final String hintText; // New variable hint text
  final Function(String)? beatifyValueFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Query(
            options: query,
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                CustomErrorHandler.captureException(result.exception);
                return const SizedBox(
                  height: 50,
                  child: Center(child: Text("Error")),
                );
              } else if (result.isLoading) {
                return const SizedBox(
                  height: 50,
                  child: Center(
                    child: ModernSkeleton(width: 100, height: 20),
                  ),
                );
              } else {
                try {
                  final List<dynamic> options = result.data![identifier];
                  return InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingMedium)
                          .copyWith(bottom: AppDimensions.spacingExtraSmall),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentOption,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setOption(newValue);
                        },
                        hint: Text(hintText), // Use the hint text variable
                        items:
                            options.map<DropdownMenuItem<String>>((dynamic e) {
                          final String value = e[valueIdentifier] as String;
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(beatifyValueFunction != null
                                ? beatifyValueFunction!(value)
                                : value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } catch (e) {
                  CustomErrorHandler.captureException(e);
                  return const SizedBox(
                    height: 50,
                    child: Center(child: Text("Error")),
                  );
                }
              }
            }),
        footnoteText != null
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Text(footnoteText!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
