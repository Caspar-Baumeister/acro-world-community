// id- uuid, primary key, unique, default: gen_random_uuid()
// event_id- uuid
// created_at- timestamp with time zone, default: now()
// updated_at- timestamp with time zone, default: now()
// question- text, nullable
// position- integer, default: 0
// is_required- boolean, default: false
class QuestionModel {
  String? id;
  String? eventId;
  String? question;
  String? title;
  String? createdAt;
  String? updatedAt;
  int? position;
  bool? isRequired;

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
      this.isRequired});

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
    };
  }
}
