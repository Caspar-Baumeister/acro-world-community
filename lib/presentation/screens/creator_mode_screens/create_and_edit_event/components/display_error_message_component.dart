import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class DisplayErrorMessageComponent extends StatelessWidget {
  const DisplayErrorMessageComponent({
    super.key,
    required String? errorMessage,
  }) : _errorMessage = errorMessage;

  final String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return _errorMessage != null
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPaddings.medium,
            ),
            child: Text(
              _errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: CustomColors.errorTextColor),
            ),
          )
        : const SizedBox(height: AppPaddings.medium);
  }
}
