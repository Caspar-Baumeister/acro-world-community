// id- uuid, primary key, unique, default: gen_random_uuid()
// created_at- timestamp with time zone, default: now()
// updated_at- timestamp with time zone, default: now()
// contingent- integer
// class_id- uuid
// name- text
// description- text

class BookingCategoryModel {
  String? id;

  int contingent;
  String? classId;
  String name;
  String? description;

  BookingCategoryModel({
    this.id,
    required this.contingent,
    this.classId,
    required this.name,
    this.description,
  });

  factory BookingCategoryModel.fromJson(Map<String, dynamic> json) {
    print("BookingCategoryModel.fromJson: $json");
    return BookingCategoryModel(
      id: json['id'],
      contingent: json['contingent'],
      classId: json['class_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson(String createdClassId) {
    return {
      'id': id,
      'contingent': contingent,
      'class_id': createdClassId,
      'name': name,
      'description': description,
    };
  }

  // empty booking category
  static BookingCategoryModel empty() {
    return BookingCategoryModel(
      contingent: 0,
      name: "",
    );
  }
}
