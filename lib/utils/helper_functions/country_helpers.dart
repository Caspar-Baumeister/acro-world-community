// Map of country code to full country name.
const Map<String, String> countryMap = {
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
  // "IN": "India",       // India is not yet supported by Stripe (preview)
  // "ID": "Indonesia",   // Indonesia is not yet supported by Stripe (preview)
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

// Function to get the full country name from the country code.

String? getCountryName(String? countryCode) {
  if (countryCode == null || countryCode.isEmpty) {
    return null;
  }
  return countryMap[countryCode.toUpperCase()];
}

// Function to get the country code from the full country name.
String? getCountryCode(String? countryName) {
  if (countryName == null || countryName.isEmpty) {
    return null;
  }
  return countryMap.entries
      .firstWhere(
          (entry) => entry.value.toLowerCase() == countryName.toLowerCase(),
          orElse: () => MapEntry("", ""))
      .key;
}
