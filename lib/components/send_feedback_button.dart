import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FeedbackPopUp extends StatefulWidget {
  const FeedbackPopUp({Key? key}) : super(key: key);

  @override
  FeedbackPopUpState createState() => FeedbackPopUpState();
}

class FeedbackPopUpState extends State<FeedbackPopUp> {
  late TextEditingController _emailController;
  final _feedbackController = TextEditingController();

  void _sendEmail() async {
    final Email email = Email(
      body: _feedbackController.text,
      subject: 'Feedback from AcroWorld App',
      recipients: ['info@acroworld.de'],
      cc: [_emailController.text],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if (error is PlatformException && error.code == 'not_available') {
        Fluttertoast.showToast(
            msg:
                "No email clients found! Please install or setup an email client to send feedback.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "An error occurred while sending feedback. Please try again later.",
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
    _emailController = TextEditingController(
        text: Provider.of<UserProvider>(context, listen: false)
            .activeUser!
            .email!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Give Feedback'),
      content: Column(
        children: <Widget>[
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
              placeholder: "Feedback",
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
