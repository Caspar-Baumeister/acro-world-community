import 'package:acroworld/components/text_with_leading_icon.dart';
import 'package:flutter/material.dart';

class RegisterInfo extends StatelessWidget {
  const RegisterInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Why AcroWorld",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "The one and only Acroyoga app you need.",
                  style: TextStyle(fontSize: 12),
                  maxLines: 5,
                ),
                SizedBox(height: 15),
                TextWithLeadingIcon(
                  icon: ImageIcon(
                    AssetImage("assets/check.png"),
                    color: Colors.green,
                  ),
                  text: Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "With one click you will always know where and when classes and jams are taking place in your area.",
                      // "Stay in touch with the community with the best from Whatsapp and Facebook groups tailored to acro",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextWithLeadingIcon(
                  icon: ImageIcon(
                    AssetImage("assets/check.png"),
                    color: Colors.green,
                  ),
                  text: Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "Find out not only who the best teachers in your area are, but also exactly what they offer",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextWithLeadingIcon(
                  icon: ImageIcon(
                    AssetImage("assets/check.png"),
                    color: Colors.green,
                  ),
                  text: Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "Find out what acroyoga related events are taking place around the world",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextWithLeadingIcon(
                  icon: ImageIcon(
                    AssetImage("assets/check.png"),
                    color: Colors.green,
                  ),
                  text: Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "Keep in touch with your Acroyoga community. Find out who is participating where and when and discover the local communities when you are away from home.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            )),
      ],
    );
  }
}
