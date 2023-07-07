import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_event/single_event_body.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleEventPage extends StatelessWidget {
  const SingleEventPage({Key? key, required this.event}) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          event.name ?? "",
          maxLines: 3,
          style: HEADER_1_TEXT_STYLE.copyWith(color: Colors.black),
        ),
      ),
      bottomNavigationBar: event.pretixName != null
          ? SafeArea(
              child: BottomAppBar(
                  height: 60,
                  elevation: 0,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: StandartButton(
                        text: "Book via AcroWorld",
                        onPressed: () => launchUrl(Uri.https(
                            "booking.acroworld.de", event.pretixName!))),
                  ))),
            )
          : null,
      body: SingleEventBody(
        event: event,
      ),
    );
  }
}
