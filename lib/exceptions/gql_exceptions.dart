import 'dart:convert';

/// Given a decoded GraphQL response map, returns the most user-friendly
/// error it can find, with the first letter capitalized.
String extractGraphqlError(Map<String, dynamic> response) {
  final errors = response['errors'];
  if (errors is! List || errors.isEmpty) {
    return 'Unknown error occurred';
  }

  final msgs = <String>[];
  for (final raw in errors) {
    if (raw is Map<String, dynamic>) {
      final parsed = _parseSingleError(raw);
      if (parsed.isNotEmpty) msgs.add(parsed);
    }
  }

  return msgs.isNotEmpty ? msgs.join('; ') : 'Unknown error occurred';
}

String _parseSingleError(Map<String, dynamic> error) {
  final ext = error['extensions'];
  final candidates = <String>[];

  // 1) Look for a JSON blob in .message or in any stacktrace line
  if (error['message'] is String) candidates.add(error['message']);
  if (ext is Map<String, dynamic> && ext['stacktrace'] is List) {
    for (final l in ext['stacktrace']) {
      if (l is String) candidates.add(l);
    }
  }
  for (final text in candidates) {
    final m = RegExp(r'\{[\s\S]*?\}', dotAll: true).firstMatch(text);
    if (m != null) {
      var blob = m.group(0)!;
      // quote keys:  code: "X"  →  "code":"X"
      blob = blob.replaceAllMapped(
        RegExp(r'(\w+)\s*:'),
        (m) => '"${m[1]}":',
      );
      blob = blob.replaceAll(RegExp(r',\s*}'), '}'); // strip trailing commas
      try {
        final dec = json.decode(blob);
        if (dec is Map<String, dynamic>) {
          final raw = dec['message'] ?? dec['error'];
          if (raw is String && raw.isNotEmpty) {
            return _humanize(raw);
          }
        }
      } catch (_) {}
    }
  }

  // 2) Nest/Apollo shapes
  if (ext is Map<String, dynamic>) {
    final exception = ext['exception'];
    if (exception is Map<String, dynamic>) {
      final resp = exception['response'];
      if (resp is Map<String, dynamic> && resp['message'] != null) {
        return _toJoined(resp['message']);
      }
    }
    final direct = ext['response'];
    if (direct is Map<String, dynamic> && direct['message'] != null) {
      return _toJoined(direct['message']);
    }
  }

  // 3) If the raw message is a normal sentence, use it
  final rawMsg = error['message'];
  if (rawMsg is String && !_isConstantStyle(rawMsg)) {
    return _capitalizeFirst(rawMsg.trim());
  }

  // 4) Fallback to extensions.code (e.g. INTERNAL_SERVER_ERROR)
  if (ext is Map<String, dynamic> && ext['code'] != null) {
    return _humanize(ext['code'].toString());
  }

  // 5) Last resort: whatever .message says
  if (rawMsg is String) {
    return _capitalizeFirst(rawMsg.trim());
  }

  return '';
}

String _toJoined(dynamic msg) {
  if (msg is List) {
    return _capitalizeFirst(msg.join(', ').trim());
  }
  return _capitalizeFirst(msg.toString().trim());
}

/// Detects ALL-CAPS (with underscores/spaces) strings.
bool _isConstantStyle(String s) => RegExp(r'^[A-Z0-9_ ]+$').hasMatch(s);

/// Converts CONSTANT_STYLE → normal sentence, or camelCase → words.
String _humanize(String raw) {
  raw = raw.trim();
  // If it’s truly CONSTANT_STYLE, lowercase + replace underscores.
  if (_isConstantStyle(raw)) {
    final lower = raw.replaceAll('_', ' ').toLowerCase();
    return _capitalizeFirst(lower);
  }
  // Else treat as camelCase or already human text:
  final splitCamel = raw.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}');
  return _capitalizeFirst(splitCamel);
}

/// Uppercases just the first character.
String _capitalizeFirst(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
