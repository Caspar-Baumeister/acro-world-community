import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CreateCreatorProfile extends StatelessWidget {
  const CreateCreatorProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          "Creator profile",
          style: HEADER_1_TEXT_STYLE.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
