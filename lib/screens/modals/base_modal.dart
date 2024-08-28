import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
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
      padding:
          noPadding == true ? null : const EdgeInsets.all(AppPaddings.large),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.modalControllerWidth,
              height: AppDimensions.modalControllerHeight,
              decoration: BoxDecoration(
                color: CustomColors.iconColor,
                borderRadius: AppBorders.smallRadius,
              ),
            ),
            const SizedBox(height: AppPaddings.medium),
            title != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: AppPaddings.large),
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : Container(),
            child,
            const SizedBox(height: AppPaddings.medium),
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
//               BorderRadius.vertical(top: AppBorders.defaultRadius.topLeft)),
//       context: context,
//       builder: (context) => Padding(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: mordal));
// }
