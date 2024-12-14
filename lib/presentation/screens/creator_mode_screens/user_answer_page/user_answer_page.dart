import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:flutter/material.dart';

class UserAnswerPage extends StatelessWidget {
  const UserAnswerPage(
      {super.key, required this.userId, required this.classEventId});

  final String userId;
  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return BasePage(appBar: CustomAppbarSimple(), child: Container());
  }
}
