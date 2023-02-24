import 'package:acroworld/components/map.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/jam_participants_button.dart';
import 'package:acroworld/screens/single_jam_overview/jam_overview.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewJamTile extends StatelessWidget {
  const NewJamTile(
      {Key? key, required this.jam, required this.cid, this.communityName})
      : super(key: key);

  final Jam jam;
  final String cid;
  final String? communityName;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JamOverview(
            jam: jam,
            cid: cid,
          ),
        ),
      ),
      child: SizedBox(
        height: CLASS_CARD_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
            Container(
              padding: const EdgeInsets.all(6),
              width: screenWidth * 0.3,
              child: jam.latLng != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        // width: screenWidth * 0.3,
                        // height: CLASS_CARD_HEIGHT,

                        // constraints: const BoxConstraints(maxHeight: 150),
                        child: MapWidget(
                          zoom: 11.0,
                          center: jam.latLng,
                          markerLocation: jam.latLng,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jam.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      jam.date != null
                          ? "${DateFormat('H:mm').format(jam.date!)} "
                          : "",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      communityName ?? jam.community!.name,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: PARTICIPANT_BUTTON_HEIGHT,
                          child: JamParticipantsButton(
                              jamId: jam.jid!,
                              participants: jam.participants ?? [],
                              uid: userProvider.activeUser!.id!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
