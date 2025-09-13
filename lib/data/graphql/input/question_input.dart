import 'package:acroworld/data/graphql/input/multiple_choice_input.dart';
import 'package:acroworld/data/models/event/question_model.dart';

class QuestionInput {
  final String id;
  final bool allowMultipleAnswers;
  final bool isRequired;
  final int position;
  final String question;
  final String title;
  final QuestionType questionType;
  final List<MultipleChoiceOptionInput> multipleChoiceOptions;

  QuestionInput({
    required this.id,
    required this.allowMultipleAnswers,
    required this.isRequired,
    required this.position,
    required this.question,
    required this.title,
    required this.questionType,
    required this.multipleChoiceOptions,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "allow_multiple_answers": allowMultipleAnswers,
        "is_required": isRequired,
        "position": position,
        "question": question,
        "title": title,
        "question_type": questionType.value,
        "multiple_choice_options": {
          "data": multipleChoiceOptions.map((e) => e.toJson()).toList(),
          "on_conflict": {
            "constraint": "multiple_choice_option_pkey",
            "update_columns": ["id", "option_text", "position"]
          }
        }
      };
}
