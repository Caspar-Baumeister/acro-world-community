import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FeedbackPopUp extends StatefulWidget {
  const FeedbackPopUp({super.key, required this.subject, required this.title});

  final String subject;
  final String title;

  @override
  FeedbackPopUpState createState() => FeedbackPopUpState();
}

class FeedbackPopUpState extends State<FeedbackPopUp> {
  late TextEditingController _emailController;
  final _feedbackController = TextEditingController();

  void _sendEmail() async {
    final Email email = Email(
      body: _feedbackController.text,
      subject: widget.subject,
      recipients: ['info@acroworld.de'],
      cc: [_emailController.text],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if (error is PlatformException && error.code == 'not_available') {
        Fluttertoast.showToast(
            msg:
                "No email clients found! Please contact us directly at info@acroworld.de",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "An error occurred while sending feedback. Please contact us directly at info@acroworld.de",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // Handle other errors, or show a generic error message
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserProvider>(context, listen: false).activeUser != null) {
      _emailController = TextEditingController(
          text: Provider.of<UserProvider>(context, listen: false)
                  .activeUser!
                  .email ??
              "");
    } else {
      _emailController = TextEditingController(text: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10.0),
              child: const Text("Your Email")),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CupertinoTextField(
              controller: _emailController,
              placeholder: "Your Email",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CupertinoTextField(
              controller: _feedbackController,
              placeholder: "Message",
              minLines: 4,
              maxLines: 8,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('Submit'),
          onPressed: () {
            _sendEmail();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
