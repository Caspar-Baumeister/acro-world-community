class BookingObject {
  String? id;
  String? iban;
  String? email;
  String? owner;

  BookingObject({this.id, this.iban, this.owner, this.email});

  BookingObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iban = json['iban'];
    email = json['email'];
    owner = json['owner'];
  }
}
