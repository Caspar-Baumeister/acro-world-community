class UserBookingModel {
  String? classEventId;
  String? classId;
  String? urlSlug;
  String? eventName;
  String? eventImage;
  DateTime startDate;
  DateTime endDate;
  String? bookingTitle;
  String? status;
  String? locationName;

  UserBookingModel({
    required this.classEventId,
    required this.classId,
    required this.eventName,
    required this.eventImage,
    required this.startDate,
    required this.endDate,
    required this.urlSlug,
    required this.bookingTitle,
    required this.status,
    this.locationName,
  });

  // Factory constructor for creating a new UserBookingModel instance from a map.
  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    // define the start and end date if they are not null
    DateTime? startDate;
    DateTime? endDate;

    if (json['class_event']?['start_date'] != null) {
      try {
        startDate = DateTime.parse(json['class_event']?['start_date']);
      } catch (e) {
        print("error while parsing start date: $e");
      }
    }
    if (json['class_event']?['end_date'] != null) {
      try {
        endDate = DateTime.parse(json['class_event']?['end_date']);
      } catch (e) {
        print("error while parsing end date: $e");
      }
    }

    return UserBookingModel(
      classEventId: json['class_event']?['id'] as String?,
      classId: json['class_event']?['class']?['id'] as String?,
      locationName: json['class_event']?['class']?['location_name'] as String?,
      status: json['status'] as String?,
      eventName: json['class_event']?['class']?['name'] as String?,
      eventImage: json['class_event']?['class']?['image_url'] as String?,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
      bookingTitle: json['booking_option']?['title'] as String?,
      urlSlug: json['class_event']?['class']?['url_slug'] as String?,
    );
  }
}
