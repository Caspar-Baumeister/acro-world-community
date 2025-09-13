class ClassOwnerInput {
  final String id;
  final String teacherId;
  final bool isPaymentReceiver;

  ClassOwnerInput({
    required this.id,
    required this.teacherId,
    required this.isPaymentReceiver,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "is_payment_receiver": isPaymentReceiver,
      };
}
