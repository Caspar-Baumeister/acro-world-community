class GenderModel {
  String? name;
  String? id;

  GenderModel({
    required this.id,
    required this.name,
  });
  factory GenderModel.fromJson(dynamic json) {
    return GenderModel(
      name: json?["name"],
      id: json?["id"],
    );
  }
}
