class EventRating {
  String? id;
  String? eventTemplateId;
  List<String>? teacherIds;
  String? text;
  int? stars;

  EventRating(
      {this.id, this.text, this.eventTemplateId, this.teacherIds, this.stars});

  EventRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    eventTemplateId = json['eventTemplateid'];
    teacherIds = json['teacherIds'];
    stars = json['stars'];
  }
}
