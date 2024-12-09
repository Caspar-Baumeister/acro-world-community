// id- uuid, primary key, unique, default: gen_random_uuid()
// question_id- uuid
// user_id- uuid
// event_occurence- uuid
// created_at- timestamp with time zone, default: now()
// updated_at- timestamp with time zone, default: now()
// answer- text

class AnswerModel {
  String? id;
  String? questionId;
  String? userId;
  String? eventOccurence;
  String? answer;
  String? createdAt;
  String? updatedAt;

  AnswerModel(
      {this.id,
      this.questionId,
      this.userId,
      this.eventOccurence,
      this.answer,
      this.createdAt,
      this.updatedAt});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      questionId: json['question_id'],
      userId: json['user_id'],
      eventOccurence: json['event_occurence'],
      answer: json['answer'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'user_id': userId,
      'event_occurence': eventOccurence,
      'answer': answer,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
