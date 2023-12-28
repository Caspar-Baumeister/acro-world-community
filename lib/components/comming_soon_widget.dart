import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({super.key, required this.header, required this.content});
  final String header;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(header, style: H18W7),
          const SizedBox(height: 5),
          Text(
            content,
            style: H12W4,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerRight,
            child: const Text(
              """
              This feature will soon be available 
              """,
              style: H10W4,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
