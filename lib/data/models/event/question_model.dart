enum QuestionType { text, multipleChoice, phoneNumber }

extension QuestionTypeExtension on QuestionType {
  String get value {
    switch (this) {
      case QuestionType.text:
        return 'TEXT';
      case QuestionType.multipleChoice:
        return 'MULTIPLE_CHOICE';
      case QuestionType.phoneNumber:
        return 'PHONE_NUMBER';
    }
  }
}

extension StringExtension on String {
  QuestionType get toQuestionType {
    switch (this) {
      case 'TEXT':
        return QuestionType.text;
      case 'MULTIPLE_CHOICE':
        return QuestionType.multipleChoice;
      case 'PHONE_NUMBER':
        return QuestionType.phoneNumber;
      default:
        return QuestionType.text;
    }
  }
}

// extension for bautiful text representation of enum
extension BeautifulTextExtension on QuestionType {
  String get name {
    switch (this) {
      case QuestionType.text:
        return "Text";
      case QuestionType.multipleChoice:
        return "Multiple Choice";
      case QuestionType.phoneNumber:
        return "Phone Number";
    }
  }
}

class QuestionModel {
  String? id;
  String? eventId;
  String? question;
  String? title;
  String? createdAt;
  String? updatedAt;
  int? position;
  bool? isRequired;
  QuestionType? type;
  bool? isMultipleChoice;
  List<MultipleChoiceOptionModel>? choices;

  // overwrite is same to say its not same if question,title, isrequired or position is different
  @override
  bool operator ==(Object other) {
    return (other is QuestionModel &&
        other.question == question &&
        other.title == title &&
        other.isRequired == isRequired &&
        other.position == position);
  }

  QuestionModel(
      {this.id,
      this.eventId,
      this.question,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.position,
      this.isRequired,
      this.type,
      this.isMultipleChoice,
      this.choices});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      eventId: json['event_id'],
      question: json['question'],
      title: json['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      position: json['position'],
      isRequired: json['is_required'],
      type: json['question_type'].toString().toQuestionType,
      isMultipleChoice: json['allow_multiple_answers'],
      choices: json['multiple_choice_options'] != null
          ? List<MultipleChoiceOptionModel>.from(json['multiple_choice_options']
              .map((x) => MultipleChoiceOptionModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson(String insertedEventId, int position) {
    return {
      'id': id,
      'event_id': insertedEventId,
      'question': question,
      'title': title,
      'position': position,
      'is_required': isRequired,
      'question_type': type?.value,
      'allow_multiple_answers': isMultipleChoice,
    };
  }
}

class MultipleChoiceOptionModel {
  String? id;
  String? questionId;
  String? optionText;
  int? position;

  MultipleChoiceOptionModel({
    this.id,
    this.questionId,
    this.optionText,
    this.position,
  });

  factory MultipleChoiceOptionModel.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceOptionModel(
      id: json['id'],
      questionId: json['question_id'],
      optionText: json['option_text'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson(String insertedQuestionId, int position) {
    return {
      'id': id,
      'question_id': insertedQuestionId,
      'option_text': optionText,
      'position': position,
    };
  }
}
