import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BaseModal extends StatelessWidget {
  const BaseModal({super.key, required this.child, this.title, this.noPadding});

  final Widget child;
  final String? title;
  final bool? noPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: noPadding == true
          ? null
          : const EdgeInsets.all(AppDimensions.spacingLarge),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            title != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingLarge),
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : Container(),
            child,
            const SizedBox(height: AppDimensions.spacingMedium),
          ]),
    );
  }
}

// // builds the modal widgets
// Future<void> buildMortal(BuildContext context, Widget mordal) {
//   FocusScope.of(context).requestFocus(FocusNode());
//   return showModalBottomSheet(
//       useSafeArea: true,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.vertical(top: BorderRadius.circular(AppDimensions.radiusMedium).topLeft)),
//       context: context,
//       builder: (context) => Padding(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: mordal));
// }
