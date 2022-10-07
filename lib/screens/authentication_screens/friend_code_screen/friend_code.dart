import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/widgets/text_wIth_leading_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome to Acroworld",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "The worlds first and largest acroyoga and acrobatics community app.\nHere you can:",
                        style: TextStyle(fontSize: 12),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 15),
                      const TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Discover local Acro-communities, teacher, jams, festivals and classes world wide",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Find the acro courses, books and equipments recommended and used by the community and get the best prices",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "See who is participating in which event, how the ratio between flyers and bases is and how well the community rates the event.",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(color: PRIMARY_COLOR),
                      const SizedBox(height: 15),
                      const Text(
                        "To protect the acroyoga community, we only allow community members into the app. For this reason you need a friend code to enter the app.",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        decoration:
                            buildInputDecoration(labelText: "Friend code"),
                        onChanged: (val) => checkCode(val),
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text:
                                    "If you are part of the community but don't know anyone who has a friend code, feel free to write us a message at ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "info@acroworld.com",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Clipboard.setData(const ClipboardData(
                                        text: "info@acroworld.com"));
                                    Fluttertoast.showToast(
                                        msg: "Email copied",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }),
                            const TextSpan(
                                text:
                                    " and explain your role in the community.",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "You already have an account? click on the Login button",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  checkCode(String val) {
    // TODO protect code from git
    if (val == "AcroWorldCommunity") {
      confirmFriend();
    }
  }
}
