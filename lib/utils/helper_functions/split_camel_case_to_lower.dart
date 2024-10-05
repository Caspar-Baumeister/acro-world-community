String splitCamelCaseToLower(String text) {
  final RegExp camelCasePattern = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return text
      .split(camelCasePattern)
      .map((word) => word.toLowerCase())
      .join(' ');
}
