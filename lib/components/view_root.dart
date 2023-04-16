import 'package:flutter/widgets.dart';

class ViewRoot extends StatelessWidget {
  const ViewRoot({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: child,
    );
  }
}
