import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class BookingInformationModal extends StatelessWidget {
  const BookingInformationModal(
      {super.key,
      required this.classEvent,
      required this.userId,
      required this.createdBy,
      required this.booking});

  final ClassEvent classEvent;
  final String userId;
  final User? createdBy;
  final ClassEventBooking booking;

  void shareEvent(ClassEvent classEvent, ClassModel clas) {
    String deeplinkUrl = "https://acroworld.net/event/${clas.urlSlug}";
    if (classEvent.id != null) {
      deeplinkUrl += "?event=${classEvent.id!}";
    }
    final String content = '''
Hi, 
I just booked ${clas.name} 
on ${DateFormat('EEEE, H:mm').format(classEvent.startDateDT)} 
in the AcroWorld app

You can join me here: $deeplinkUrl
''';

    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ClassModel clas = classEvent.classModel!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: CustomColors.primaryColor,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 12.0),
            Text(
              "You have successfully booked ${clas.name} on ${DateFormat('EEEE, H:mm').format(classEvent.startDateDT)}",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (booking.status == "WaitingForPayment")
              // show a box with the information, that you still have to pay, the amount and so on
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: CustomColors.backgroundWarningColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "You still have to pay ${(booking.amount / 100).toStringAsFixed(2)} ${booking.currency} for this booking before the event starts.",
                  textAlign: TextAlign.center,
                ),
              ),
            StandartButton(
              text: "Share with friends",
              onPressed: () => shareEvent(classEvent, clas),
              isFilled: true,
            ),
            const SizedBox(height: 15),
            if (createdBy != null)
              LinkButtonComponent(
                text: "Contact organiser",
                onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => ContactOrganiserForm(
                    organiserEmail: createdBy?.email ?? '',
                    onSend: (message, email, phone) {
                      // Handle send action
                    },
                  ),
                ),
              ),
            const SizedBox(height: 15),
            LinkButtonComponent(
              text: "Problems? Contact support",
              onPressed: () => showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => FeedbackPopUp(
                  subject:
                      'Problem with booking id:${classEvent.id}, user:$userId',
                  title: "Booking problem",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A form widget that allows users to contact the organiser by sending
/// a message along with their email and optional phone number.
class ContactOrganiserForm extends StatefulWidget {
  /// The organiser's email address to which the message will be sent.
  final String organiserEmail;

  /// Callback invoked when the user taps "Send". Provides the message,
  /// the user's email, and optionally their phone number.
  final void Function(String message, String email, String? phone) onSend;

  const ContactOrganiserForm({
    super.key,
    required this.organiserEmail,
    required this.onSend,
  });

  @override
  _ContactOrganiserFormState createState() => _ContactOrganiserFormState();
}

class _ContactOrganiserFormState extends State<ContactOrganiserForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);

    final message = _messageController.text.trim();
    final email = _emailController.text.trim();
    final phoneRaw = _phoneController.text.trim();
    final phone = phoneRaw.isEmpty ? null : phoneRaw;

    print("Sending message: $message");

    widget.onSend(message, email, phone);

    // Optionally clear fields or close form after sending
    // Navigator.of(context).pop();
    setState(() => _isSending = false);
    Navigator.of(context).pop(); // Close the modal after sending
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Organiser',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),

              // Message field
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Your message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Your email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone field (optional)
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isSending ? null : _submit,
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
