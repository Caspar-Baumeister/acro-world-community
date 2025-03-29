import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneQuestionInput extends StatefulWidget {
  final TextEditingController controller;

  const PhoneQuestionInput({super.key, required this.controller});

  @override
  State<PhoneQuestionInput> createState() => _PhoneQuestionInputState();
}

class _PhoneQuestionInputState extends State<PhoneQuestionInput> {
  final Map<String, String> _countryCodes = {
    "AU": "Australia",
    "AT": "Austria",
    "BE": "Belgium",
    "BG": "Bulgaria",
    "BR": "Brazil",
    "CA": "Canada",
    "HR": "Croatia",
    "CY": "Cyprus",
    "CZ": "Czech Republic",
    "DK": "Denmark",
    "EE": "Estonia",
    "FI": "Finland",
    "FR": "France",
    "DE": "Germany",
    "GR": "Greece",
    "HK": "Hong Kong",
    "HU": "Hungary",
    "IE": "Ireland",
    "IT": "Italy",
    "JP": "Japan",
    "LV": "Latvia",
    "LI": "Liechtenstein",
    "LT": "Lithuania",
    "LU": "Luxembourg",
    "MY": "Malaysia",
    "MT": "Malta",
    "MX": "Mexico",
    "NL": "Netherlands",
    "NZ": "New Zealand",
    "NG": "Nigeria",
    "NO": "Norway",
    "PL": "Poland",
    "PT": "Portugal",
    "RO": "Romania",
    "SG": "Singapore",
    "SK": "Slovakia",
    "SI": "Slovenia",
    "ZA": "South Africa",
    "ES": "Spain",
    "SE": "Sweden",
    "CH": "Switzerland",
    "TH": "Thailand",
    "AE": "United Arab Emirates",
    "GB": "United Kingdom",
    "US": "United States",
  };

  final Map<String, String> _countryDialCodes = {
    "AU": "+61",
    "AT": "+43",
    "BE": "+32",
    "BG": "+359",
    "BR": "+55",
    "CA": "+1",
    "HR": "+385",
    "CY": "+357",
    "CZ": "+420",
    "DK": "+45",
    "EE": "+372",
    "FI": "+358",
    "FR": "+33",
    "DE": "+49",
    "GR": "+30",
    "HK": "+852",
    "HU": "+36",
    "IE": "+353",
    "IT": "+39",
    "JP": "+81",
    "LV": "+371",
    "LI": "+423",
    "LT": "+370",
    "LU": "+352",
    "MY": "+60",
    "MT": "+356",
    "MX": "+52",
    "NL": "+31",
    "NZ": "+64",
    "NG": "+234",
    "NO": "+47",
    "PL": "+48",
    "PT": "+351",
    "RO": "+40",
    "SG": "+65",
    "SK": "+421",
    "SI": "+386",
    "ZA": "+27",
    "ES": "+34",
    "SE": "+46",
    "CH": "+41",
    "TH": "+66",
    "AE": "+971",
    "GB": "+44",
    "US": "+1",
  };

  String _selectedCountry = "DE";

  @override
  Widget build(BuildContext context) {
    final dialCode = _countryDialCodes[_selectedCountry] ?? "";

    final sortedCountryCodes = _countryCodes.keys.toList()..sort();

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
                }
              },
              items: sortedCountryCodes.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    children: [
                      Flag.fromString(code, height: 20, width: 30),
                      const SizedBox(width: 8),
                      Text("$code (${_countryDialCodes[code]})"),
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
