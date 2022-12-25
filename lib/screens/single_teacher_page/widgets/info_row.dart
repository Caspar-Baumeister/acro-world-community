import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow(
      {Key? key,
      required this.value,
      required this.attributeKey,
      required this.isEdit,
      this.dBKey})
      : super(key: key);
  final String value;
  final String attributeKey;
  final bool isEdit;
  final String? dBKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            attributeKey,
            maxLines: 2,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            maxLines: 2,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
