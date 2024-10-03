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
          Text(header, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(
            content,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              """
              This feature will soon be available 
              """,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
