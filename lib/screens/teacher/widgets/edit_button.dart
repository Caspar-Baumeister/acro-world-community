import 'package:acroworld/components/framed_button.dart';
import 'package:acroworld/screens/teacher/widgets/edit_pop_up.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key, this.size = 18, required this.header})
      : super(key: key);

  final double? size;
  final String header;

  @override
  Widget build(BuildContext context) {
    return FramedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => EditPopUp(header: header));
      },
      child: Icon(
        Icons.edit,
        color: Colors.black,
        size: size,
      ),
    );
  }
}
