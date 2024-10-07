import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool makeScrollable;
  final Widget? endDrawer;
  const BasePage(
      {super.key,
      required this.child,
      this.bottomNavigationBar,
      this.endDrawer,
      this.appBar,
      this.makeScrollable = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: makeScrollable
            ? SingleChildScrollView(
                child: child,
              )
            : child,
      ),
      bottomNavigationBar: bottomNavigationBar,
      endDrawer: endDrawer,
    );
  }
}
