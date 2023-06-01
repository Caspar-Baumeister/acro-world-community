// builds the modal widgets
import 'package:flutter/material.dart';

Future<void> buildMortal(BuildContext context, Widget mordal) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    context: context,
    builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: mordal),
  );
}
