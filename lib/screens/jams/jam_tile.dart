import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_jam_overview/jam_overview.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JamTile extends StatelessWidget {
  const JamTile(
      {required this.jam, required this.cid, this.communityName, Key? key})
      : super(key: key);

  final Jam jam;
  final String cid;
  final String? communityName;

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context, listen: false).getId();
    List<String?>? uids = jam.participants != null
        ? jam.participants!.map((e) => e.id).toList()
        : [];
    bool paticipate = uids.contains(uid);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JamOverview(
            jam: jam,
            cid: cid,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: paticipate ? SUCCESS_COLOR : PRIMARY_COLOR,
            width: paticipate ? 4.0 : 1,
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 300.0),
        child: ListTile(
          title: Text(jam.name ?? ""),
          subtitle: jam.date != null
              ? Text(DateFormat('kk:mm').format(jam.date!))
              : null,
          // Text(timeago.format(jam.date, allowFromNow: true),
          //     locale: const Locale('de', 'DE')),
          trailing: communityName != null
              ? Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        communityName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${jam.participants?.length.toString() ?? "0"} participants",
                      ),
                    ],
                  ),
                )
              : Text(
                  "${jam.participants?.length.toString() ?? "0"} participants"),
        ),
      ),
    );
  }
}
