import 'package:flutter/material.dart';

class SingleClassPage extends StatelessWidget {
  const SingleClassPage({Key? key, required this.classId}) : super(key: key);

  final String classId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: Text(classId),
      ),
    );
  }
}
