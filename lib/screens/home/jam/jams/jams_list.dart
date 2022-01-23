import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jams/jam_tile.dart';
import 'package:flutter/material.dart';

class JamsList extends StatelessWidget {
  const JamsList({
    Key? key,
    required this.jams,
    required this.cid,
  }) : super(key: key);

  final List<Jam> jams;
  final String cid;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final jam = jams[index];
        return JamTile(
          jam: jam,
          cid: cid,
        );
      },
      reverse: true,
      itemCount: jams.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}
