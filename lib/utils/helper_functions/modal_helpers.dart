// builds the modal widgets
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

Future<void> buildMortal(BuildContext context, Widget mordal) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLarge),
      ),
    ),
    context: context,
    builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: mordal),
  );
}
