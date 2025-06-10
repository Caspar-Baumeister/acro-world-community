import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackPopUp extends ConsumerStatefulWidget {
  const FeedbackPopUp({super.key, required this.subject, required this.title});

  final String subject;
  final String title;

  @override
  ConsumerState<FeedbackPopUp> createState() => _FeedbackPopUpState();
}

class _FeedbackPopUpState extends ConsumerState<FeedbackPopUp> {
  late final TextEditingController _emailController;
  final _feedbackController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
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
        showErrorToast(
          "No email clients found! Please contact us at info@acroworld.de",
        );
      } else {
        showErrorToast(
          "An error occurred sending feedback. Please contact us at info@acroworld.de",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userRiverpodProvider);

    userAsync.whenData((user) {
      if (!_initialized) {
        _emailController.text = user?.email ?? '';
        _initialized = true;
      }
    });

    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Your Email"),
            ),
          ),
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
