import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/screens/HOME_SCREENS/activities/components/community_query_widget.dart';
import 'package:acroworld/screens/jams/jam_tile.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JamsView extends StatelessWidget {
  const JamsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    List<Jam> jams = activityProvider.activeJams;
    try {
      jams.sort(
          (a, b) => b.dateAsDateTime!.isBefore(a.dateAsDateTime!) ? 1 : 0);
    } catch (e) {
      print(e.toString());
    }
    jams.sort((a, b) => b.dateAsDateTime!.isBefore(a.dateAsDateTime!) ? 1 : 0);

    return Column(
      children: [
        StandartButton(
          text: "Plan a jam",
          onPressed: () => buildMortal(
            context,
            UserCommunityQuery(
              day: activityProvider.activeDay,
            ),
          ),
        ),
        const SizedBox(height: 10),
        jams.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("no jam found"),
                  )
                ],
              )
            : Flexible(
                child: ListView.builder(
                  itemCount: jams.length,
                  itemBuilder: (context, index) {
                    return JamTile(jam: jams[index]);
                  },
                ),
              )
        // Flexible(
        //     child: JamsViewQuery(day: day, place: place, from: from, to: to)),
      ],
    );
  }
}
