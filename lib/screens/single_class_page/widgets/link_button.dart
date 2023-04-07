import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.link, required this.text})
      : super(key: key);

  final String link;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () async {
          Uri url = Uri.parse(link);
          if (!await launchUrl(url)) {
            throw 'Could not launch $url';
          }
        },
        child: Text(text,
            maxLines: 1,
            style: MEDIUM_TEXT_STYLE.copyWith(color: Colors.black)),
      ),
    );
  }
}
