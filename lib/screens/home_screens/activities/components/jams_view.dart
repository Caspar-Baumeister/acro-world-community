import 'package:acroworld/components/custom_button.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/home_screens/activities/components/community_query_widget.dart';
import 'package:acroworld/screens/home_screens/activities/components/jams_view_query.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class JamsView extends StatelessWidget {
  const JamsView({Key? key, required this.place, required this.day})
      : super(key: key);
  final Place? place;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          "Plan a jam",
          () => buildMortal(
              context,
              UserCommunityQuery(
                day: day,
              )),
        ),
        const SizedBox(height: 6),
        Flexible(
            child: JamsViewQuery(
          day: day,
          place: place,
        )),
      ],
    );
  }
}
