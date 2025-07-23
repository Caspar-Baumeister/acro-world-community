import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneQuestionInput extends StatefulWidget {
  final String? initialValue;
  final String? initialDialCode;
  final void Function(String phone, String dialCode)? onChanged;

  const PhoneQuestionInput({
    super.key,
    this.initialValue,
    this.initialDialCode,
    this.onChanged,
  });

  @override
  State<PhoneQuestionInput> createState() => _PhoneQuestionInputState();
}

class _PhoneQuestionInputState extends State<PhoneQuestionInput> {
  late TextEditingController _controller;
  late String _selectedCountry;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue ?? "");
    _selectedCountry = widget.initialDialCode != null
        ? stripeSupportedCountryDialCodes.entries
            .firstWhere((e) => e.value == widget.initialDialCode,
                orElse: () => const MapEntry("DE", "+49"))
            .key
        : "DE";
  }

  @override
  Widget build(BuildContext context) {
    final dialCode = stripeSupportedCountryDialCodes[_selectedCountry] ?? "";

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
                  widget.onChanged?.call(_controller.text.trim(),
                      stripeSupportedCountryDialCodes[value] ?? "");
                }
              },
              items: stripeSupportedCountries.keys
                  .toList()
                  .map((code) => DropdownMenuItem<String>(
                        value: code,
                        child: Row(
                          children: [
                            Flag.fromString(code, height: 20, width: 30),
                            const SizedBox(width: 8),
                            Text(
                                "$code (${stripeSupportedCountryDialCodes[code]})"),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9 ]")),
                ],
                onChanged: (value) {
                  widget.onChanged?.call(value.trim(),
                      stripeSupportedCountryDialCodes[_selectedCountry] ?? "");
                },
                decoration: InputDecoration(prefixText: "$dialCode "),
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
