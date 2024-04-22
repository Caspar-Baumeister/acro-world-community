// builds the modal widgets
import 'package:flutter/material.dart';

Future<void> buildMortal(BuildContext context, Widget mordal) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: mordal),
  );
}
