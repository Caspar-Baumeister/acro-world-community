// import http
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getTimezone(double latitude, double longitude) async {
  const String username = 'acroworld'; // Your GeoNames username
  final String url =
      'http://api.geonames.org/timezoneJSON?lat=$latitude&lng=$longitude&username=$username';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('timezoneId')) {
        return data['timezoneId'];
      } else {
        print(
            'Timezone ID not found in the response. Returning default timezone.');
        return 'Europe/Berlin'; // Default to Germany timezone
      }
    } else {
      print(
          'Failed to load timezone. Status code: ${response.statusCode}. Returning default timezone.');
      return 'Europe/Berlin'; // Default to Germany timezone
    }
  } catch (e) {
    print('An error occurred: $e. Returning default timezone.');
    return 'Europe/Berlin'; // Default to Germany timezone
  }
}
