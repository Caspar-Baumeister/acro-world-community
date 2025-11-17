import 'package:acroworld/presentation/components/backgrounds/creator_mode_gradient_background.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool makeScrollable;
  final Widget? endDrawer;
  final bool useCreatorGradient;
  const BasePage({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.endDrawer,
    this.appBar,
    this.makeScrollable = true,
    this.useCreatorGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final bodyContent = SafeArea(
      child: makeScrollable
          ? SingleChildScrollView(
              child: child,
            )
          : child,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: useCreatorGradient
          ? Colors.transparent
          : Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: useCreatorGradient
          ? CreatorModeGradientBackground(child: bodyContent)
          : bodyContent,
      bottomNavigationBar: bottomNavigationBar,
      endDrawer: endDrawer,
    );
  }
}
