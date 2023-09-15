class EventType {
  String? id;
  String? name;

  EventType({
    this.id,
    this.name,
  });

  EventType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
