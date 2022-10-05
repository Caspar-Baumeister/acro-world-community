import 'package:acroworld/shared/helper_builder.dart';
import 'package:flutter/material.dart';

class FriendCode extends StatelessWidget {
  const FriendCode(
      {Key? key, required this.confirmFriend, required this.toggleView})
      : super(key: key);

  final Function confirmFriend;
  final Function toggleView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text('Register for Acro World'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => toggleView(),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text(
                      "Type your suggestion code below",
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      decoration: buildInputDecoration(labelText: "code"),
                      onChanged: (val) => checkCode(val),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "We do our best to protect the community and set the focus of this app for communiycation and planing inside the acro yoga community",
                      style: TextStyle(fontSize: 12),
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ],
        ));
  }

  checkCode(String val) {
    // TODO protect code from git
    if (val == "AcroWorldCommunity") {
      confirmFriend();
    }
  }
}
