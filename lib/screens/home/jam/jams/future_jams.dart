import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/jam/jams/jams_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FutureJams extends StatefulWidget {
  const FutureJams({Key? key, required this.cId}) : super(key: key);

  final String cId;

  @override
  State<FutureJams> createState() => _FutureJamsState();
}

class _FutureJamsState extends State<FutureJams> {
  @override
  Widget build(BuildContext context) {
    //final UserProvider user = Provider.of<UserProvider>(context, listen: true);
    return FutureBuilder<List<Jam>?>(
        future: loadJams(context),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            //Provider.of<User?>(context)?.reload();
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            List<Jam>? data = snapshot.data;
            return RefreshIndicator(
              onRefresh: (() async => data = await loadJams(context)),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: JamsBody(
                    jams: data ?? [],
                    cId: widget.cId,
                  ),
                ),
              ),
            );
          }
          return const LoadingScaffold();
        }));
  }

  Future<List<Jam>?> loadJams(BuildContext context) async {
    print("loadjams executed");
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return null;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    final database = Database(token: token);
    final response = await database.getCommunityJams(widget.cId);
    List jams = response["data"]["jams"];

    return List<Jam>.from(jams.map((jam) => Jam(
        jid: jam["id"],
        createdAt: DateTime.parse(jam["created_at"]),
        createdBy: jam["created_by_id"],
        participants: [],
        date: DateTime.parse(jam["date"]),
        name: jam["name"],
        // imgUrl: "",
        info: jam["info"],
        latLng: LatLng(jam["latitude"], jam["longitude"]))));
  }
}
