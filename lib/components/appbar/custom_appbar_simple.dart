import 'package:acroworld/components/appbar/base_appbar.dart';
import 'package:flutter/material.dart';

class CustomAppbarSimple extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool isBackButton;

  const CustomAppbarSimple(
      {super.key, this.title, this.actions, this.isBackButton = true});

  @override
  Widget build(BuildContext context) {
    return BaseAppbar(
      title: Text(title ?? "", style: Theme.of(context).textTheme.titleLarge),
      actions: actions,
      leading: isBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
