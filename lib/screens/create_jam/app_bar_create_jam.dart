import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:flutter/material.dart';

class AppBarJam extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarJam({
    Key? key,
    required this.title,
    required this.onSubmit,
  }) : super(key: key);

  final String title;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(title, style: const TextStyle(color: Colors.black)),
      leading: const BackButtonWidget(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StandartButton(
            onPressed: () => onSubmit(),
            text: 'Submit',
            isFilled: true,
            width: 100,
          ),
        ),
      ],
    );
  }
}
