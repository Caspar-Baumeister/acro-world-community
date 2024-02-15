import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.link, required this.text});

  final String link;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: FilledButton(
        // set fillcolor to white
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          // set border to black and width to 1
          side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: Colors.black, width: 1)),
        ),
        onPressed: () async {
          await customLaunch(link);
        },
        child: Text(text,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black)),
      ),
    );
  }
}
