import 'package:acroworld/screens/home/communities/modals/create_new_community.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';

class NewCommunityButton extends StatelessWidget {
  const NewCommunityButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.white, elevation: 0),
        onPressed: () => buildMortal(context, CreateNewCommunityModal()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            SizedBox(
              height: 30,
              child: ImageIcon(
                AssetImage("assets/add-all.png"),
                color: Colors.black,
              ),
            ),
            Text("New",
                style: TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
