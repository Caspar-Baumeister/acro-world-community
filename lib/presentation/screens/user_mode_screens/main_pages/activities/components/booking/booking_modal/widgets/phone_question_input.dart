import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneQuestionInput extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController prefixController;

  const PhoneQuestionInput(
      {super.key, required this.controller, required this.prefixController});

  @override
  State<PhoneQuestionInput> createState() => _PhoneQuestionInputState();
}

class _PhoneQuestionInputState extends State<PhoneQuestionInput> {
  String _selectedCountry = "DE";

  @override
  void initState() {
    super.initState();
    if (widget.prefixController.text.isNotEmpty) {
      _selectedCountry = stripeSupportedCountryDialCodes.entries
          .firstWhere(
              (element) => element.value == widget.prefixController.text)
          .key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialCode = stripeSupportedCountryDialCodes[_selectedCountry] ?? "";

    final sortedCountryCodes = stripeSupportedCountries.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phone number"),
        const SizedBox(height: 8),
        Row(
          children: [
            DropdownButton<String>(
              value: _selectedCountry,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCountry = value);
                  widget.prefixController.text =
                      stripeSupportedCountryDialCodes[value] ?? "";
                }
              },
              items: sortedCountryCodes.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    children: [
                      Flag.fromString(code, height: 20, width: 30),
                      const SizedBox(width: 8),
                      Text("$code (${stripeSupportedCountryDialCodes[code]})"),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                // only allow numbers and spaces
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9 ]")),
                ],

                decoration: InputDecoration(
                  prefixText: "$dialCode ",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Example: $dialCode 157 12345678",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
