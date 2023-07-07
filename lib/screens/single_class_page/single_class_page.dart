import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_body.dart';
import 'package:flutter/material.dart';

class SingleClassPage extends StatelessWidget {
  const SingleClassPage({Key? key, required this.clas}) : super(key: key);

  final ClassModel clas;

  @override
  Widget build(BuildContext context) {
    print("inside single clas page");
    print(clas.id);
    return Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Text(clas.name ?? "",
              maxLines: 3,
              style: const TextStyle(color: Colors.black, fontSize: 18)),
        ),
        body: SingleClassBody(classe: clas));
  }
}
