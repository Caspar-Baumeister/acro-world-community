import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/calender/calender_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FutureCalenderJams extends StatefulWidget {
  const FutureCalenderJams({Key? key}) : super(key: key);

  @override
  State<FutureCalenderJams> createState() => _FutureCalenderJamsState();
}

class _FutureCalenderJamsState extends State<FutureCalenderJams> {
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
                  child: CalenderBody(
                    userJams: data ?? [],
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
    // get all jams from my communities
    //final response = await database.getUserJams(widget.cId);

    // get all participated jams
    final response = await database.getJamsFromMyComs();
    print(response.toString());

    //Provider.of<UserProvider>(context, listen: false).activeUser!.uid

    List<Map<String, dynamic>> jams = [];

    for (Map<String, dynamic> com in response["data"]["me"][0]["communities"]) {
      for (Map<String, dynamic> jam in com["community"]["jams"]) {
        jams.add(jam);
      }
    }

    // manage response of getJamsParticipated
    //final jams = response["data"]["me"][0]["participates"];

    final jamList = List<Jam>.from(jams.map((jam) {
      final jamObject = Jam(
          cid: jam["community_id"],
          jid: jam["id"],
          createdAt: DateTime.parse(jam["created_at"]),
          createdBy: jam["created_by_id"],
          participants: [],
          date: DateTime.parse(jam["date"]),
          name: jam["name"],
          // imgUrl: "",
          info: jam["info"],
          latLng: LatLng(jam["latitude"], jam["longitude"]));

      return jamObject;
    }));

    return jamList;
  }
}
