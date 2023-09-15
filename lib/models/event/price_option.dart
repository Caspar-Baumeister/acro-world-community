class PriceOption {
  String? id;
  String? description;
  double? price;
  int? amount;

  PriceOption({this.id, this.description, this.price, this.amount});

  PriceOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    price = json['price'];
    amount = json['amount'];
  }
}
