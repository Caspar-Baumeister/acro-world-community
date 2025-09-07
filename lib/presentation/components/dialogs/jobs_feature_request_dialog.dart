import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsFeatureRequestDialog extends ConsumerStatefulWidget {
  const JobsFeatureRequestDialog({super.key});

  @override
  ConsumerState<JobsFeatureRequestDialog> createState() => _JobsFeatureRequestDialogState();
}

class _JobsFeatureRequestDialogState extends ConsumerState<JobsFeatureRequestDialog> {
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

  Future<void> _sendFeatureRequest() async {
    final Email email = Email(
      body: _feedbackController.text.isNotEmpty 
          ? "Feature Request: Jobs Dashboard\n\nAdditional remarks:\n${_feedbackController.text}"
          : "Feature Request: Jobs Dashboard\n\nI am interested in this feature and would like to be notified when it becomes available.",
      subject: 'Jobs Dashboard Feature Request',
      recipients: ['info@acroworld.de'],
      cc: [_emailController.text],
    );

    try {
      await FlutterEmailSender.send(email);
      showSuccessToast("Feature request sent successfully!");
    } catch (error) {
      if (error is PlatformException && error.code == 'not_available') {
        showErrorToast(
          "No email clients found! Please contact us at info@acroworld.de",
        );
      } else {
        showErrorToast(
          "An error occurred sending your request. Please contact us at info@acroworld.de",
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
      title: const Text("Jobs Dashboard Coming Soon!"),
      content: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              "You will soon be able to post open job offers for performers, teachers, medics, or other community members for your events or studios.\n\nIf you are interested in this feature, let us know below with or without any remarks. We will only build this feature if it is wished for by the community.",
              textAlign: TextAlign.center,
            ),
          ),
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Additional Remarks (Optional)"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CupertinoTextField(
              controller: _feedbackController,
              placeholder: "Tell us more about how you'd use this feature...",
              minLines: 3,
              maxLines: 5,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('Not Interested'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('I Want This Feature'),
          onPressed: () {
            _sendFeatureRequest();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
