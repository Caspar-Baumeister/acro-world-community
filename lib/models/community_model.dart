class Community {
  String name;
  String id;
  DateTime nextJam;
  bool confirmed;
  Community(
      {required this.id,
      required this.nextJam,
      required this.name,
      required this.confirmed});

  factory Community.fromJson(String id, dynamic json) {
    return Community(
        id: id,
        nextJam: json["next_jam"].toDate(),
        name: json["name"],
        confirmed: json["confirmed"]);
  }
}
