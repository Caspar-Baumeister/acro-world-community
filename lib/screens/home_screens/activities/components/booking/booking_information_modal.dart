import 'package:acroworld/components/buttons/link_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/send_feedback_button.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class BookingInformationModal extends StatelessWidget {
  const BookingInformationModal(
      {super.key, required this.classEvent, required this.userId});

  final ClassEvent classEvent;
  final String userId;

  void shareEvent(ClassEvent classEvent, ClassModel clas) {
    final String content = '''
Hi, 
I just booked ${clas.name} 
on ${DateFormat('EEEE, H:mm').format(classEvent.startDateDT)} 
in the AcroWorld app
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
              color: PRIMARY_COLOR,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 12.0),
            Text(
              "You have successfully booked ${clas.name} on ${DateFormat('EEEE, H:mm').format(classEvent.startDateDT)}",
              style: H16W7,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            StandardButton(
              text: "Share with friends",
              onPressed: () => shareEvent(classEvent, clas),
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
