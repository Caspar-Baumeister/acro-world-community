import 'package:acroworld/theme/app_dimensions.dart';
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
              horizontal: AppDimensions.spacingMedium,
            ),
            child: Text(
              _errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            ),
          )
        : const SizedBox(height: AppDimensions.spacingMedium);
  }
}
