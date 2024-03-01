// file: lib/utils/currency_details.dart

class CurrencyDetail {
  final String value;
  final String label;
  final String symbol;

  CurrencyDetail(
      {required this.value, required this.label, required this.symbol});

  static CurrencyDetail getCurrencyDetail(String currencyCode) {
    Map<String, CurrencyDetail> currencyDetails = {
      'EUR': CurrencyDetail(value: 'EUR', label: 'Euro (EUR)', symbol: '€'),
      'USD':
          CurrencyDetail(value: 'USD', label: 'US Dollar (USD)', symbol: '\$'),
      'GBP': CurrencyDetail(
          value: 'GBP', label: 'British Pound (GBP)', symbol: '£'),
      'AED': CurrencyDetail(
          value: 'AED',
          label: 'United Arab Emirates Dirham (AED)',
          symbol: 'AED'),
      'AUD': CurrencyDetail(
          value: 'AUD', label: 'Australian Dollar (AUD)', symbol: 'A\$'),
      'BRL': CurrencyDetail(
          value: 'BRL', label: 'Brazilian Real (BRL)', symbol: 'R\$'),
      'CAD': CurrencyDetail(
          value: 'CAD', label: 'Canadian Dollar (CAD)', symbol: 'CA\$'),
      'CHF': CurrencyDetail(
          value: 'CHF', label: 'Swiss Franc (CHF)', symbol: 'CHF'),
      'CNY': CurrencyDetail(
          value: 'CNY', label: 'Chinese Yuan (CNY)', symbol: '¥'),
      'HKD': CurrencyDetail(
          value: 'HKD', label: 'Hong Kong Dollar (HKD)', symbol: 'HK\$'),
      'INR': CurrencyDetail(
          value: 'INR', label: 'Indian Rupee (INR)', symbol: '₹'),
      'JPY': CurrencyDetail(
          value: 'JPY', label: 'Japanese Yen (JPY)', symbol: '¥'),
      'MXN': CurrencyDetail(
          value: 'MXN', label: 'Mexican Peso (MXN)', symbol: 'Mex\$'),
      'NZD': CurrencyDetail(
          value: 'NZD', label: 'New Zealand Dollar (NZD)', symbol: 'NZ\$'),
      'SEK': CurrencyDetail(
          value: 'SEK', label: 'Swedish Krona (SEK)', symbol: 'kr'),
      'SGD': CurrencyDetail(
          value: 'SGD', label: 'Singapore Dollar (SGD)', symbol: 'S\$'),
      'ZAR': CurrencyDetail(
          value: 'ZAR', label: 'South African Rand (ZAR)', symbol: 'R'),
      // Add more currencies as needed
    };

    return currencyDetails[currencyCode] ??
        CurrencyDetail(
            value: currencyCode, label: 'Unknown Currency', symbol: '');
  }
}
