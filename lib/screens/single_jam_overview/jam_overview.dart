import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_jam_overview/app_bar_jam_overview.dart';
import 'package:acroworld/screens/single_jam_overview/body_jam_overview.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JamOverview extends StatefulWidget {
  const JamOverview({required this.jam, required this.cid, Key? key})
      : super(key: key);
  final Jam jam;
  final String cid;

  @override
  State<JamOverview> createState() => _JamOverviewState();
}

class _JamOverviewState extends State<JamOverview> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).activeUser!;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarJamOverview(jam: widget.jam),
        body: loading
            ? const LoadingWidget()
            : JamOverviewBody(jam: widget.jam, cid: widget.cid));
  }
}
