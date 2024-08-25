import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
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

  final String? currentOption;
  final Function(String) onOptionSet;
  final List<String> options;
  final String hintText;
  final String? footnoteText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: CustomColors.primaryTextColor),
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppPaddings.medium)
                    .copyWith(bottom: AppPaddings.tiny),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          child: SizedBox(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentOption,
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
                  ...options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
                          color: CustomColors.primaryTextColor,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
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
      this.hintText = "Choose a value"}); // Default hint text

  final String? footnoteText;
  final QueryOptions query;
  final String identifier;
  final String? currentOption;
  final Function(String? value) setOption;
  final String valueIdentifier;
  final String hintText; // New variable hint text

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
                  child: Center(child: CircularProgressIndicator()),
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
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppPaddings.medium)
                          .copyWith(bottom: AppPaddings.tiny),
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
                            child: Text(value),
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
                          color: CustomColors.primaryTextColor,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
