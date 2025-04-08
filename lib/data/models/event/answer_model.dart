// id- uuid, primary key, unique, default: gen_random_uuid()
// question_id- uuid
// user_id- uuid
// event_occurence- uuid
// created_at- timestamp with time zone, default: now()
// updated_at- timestamp with time zone, default: now()
// answer- text

// id
//       answer
//       question_id
//       user_id
//       event_occurence
//        multiple_choice_answers {
//         is_correct
//         id
//         multiple_choice_option_id
//         user_id
//         answer_id
//       }

class AnswerModel {
  String? id;
  String? questionId;
  String? userId;
  String? eventOccurence;
  String? answer;
  String? createdAt;
  String? updatedAt;
  List<MultipleChoiceAnswerModel>? multipleChoiceAnswers;
  String? countryDialCode;

  AnswerModel(
      {this.id,
      this.questionId,
      this.userId,
      this.eventOccurence,
      this.answer,
      this.createdAt,
      this.multipleChoiceAnswers,
      this.updatedAt,
      this.countryDialCode});

  // to string method to print the answer
  @override
  String toString() {
    return 'AnswerModel{id: $id, questionId: $questionId, userId: $userId, eventOccurence: $eventOccurence, answer: $answer, createdAt: $createdAt, updatedAt: $updatedAt, multipleChoiceAnswers: ${multipleChoiceAnswers?.map((e) => e.multipleChoiceOptionId)}}';
  }

  // overwrite equality operator to compare objects only after their answers
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnswerModel && other.answer == answer;
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      questionId: json['question_id'],
      userId: json['user_id'],
      eventOccurence: json['event_occurence'],
      answer: json['answer'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      countryDialCode: json['country_dial_code'],
      multipleChoiceAnswers: json['multiple_choice_answers'] != null
          ? List<MultipleChoiceAnswerModel>.from(json['multiple_choice_answers']
              .map((x) => MultipleChoiceAnswerModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> answerJson = {
      'question_id': questionId,
      'user_id': userId,
      'event_occurence': eventOccurence,
      'answer': answer,
      'country_dial_code': countryDialCode,
    };
    if (id != null) {
      answerJson['id'] = id;
    }
    return answerJson;
  }
}

class MultipleChoiceAnswerModel {
  String? id;
  String? multipleChoiceOptionId;
  String? userId;
  String? answerId;
  bool? isCorrect;

  MultipleChoiceAnswerModel(
      {this.id,
      this.multipleChoiceOptionId,
      this.userId,
      this.answerId,
      this.isCorrect});

  factory MultipleChoiceAnswerModel.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceAnswerModel(
      id: json['id'],
      multipleChoiceOptionId: json['multiple_choice_option_id'],
      userId: json['user_id'],
      answerId: json['answer_id'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> multipleChoiceAnswerJson = {
      'multiple_choice_option_id': multipleChoiceOptionId,
      'user_id': userId,
      'answer_id': answerId,
      'is_correct': isCorrect,
    };
    if (id != null) {
      multipleChoiceAnswerJson['id'] = id;
    }
    return multipleChoiceAnswerJson;
  }
}
