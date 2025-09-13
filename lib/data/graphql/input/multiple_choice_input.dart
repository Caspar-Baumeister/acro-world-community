class MultipleChoiceOptionInput {
  final String id;
  final String optionText;
  final int position;

  MultipleChoiceOptionInput({
    required this.id,
    required this.optionText,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "option_text": optionText,
        "position": position,
      };
}
