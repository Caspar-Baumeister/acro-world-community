import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/all_communities_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/querys.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';

class FutureAllCommunity extends StatelessWidget {
  const FutureAllCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO show the communities from provider and reload them in the background
    // TODO refresh the reload with refresh widget
    return FutureBuilder<List<Community>>(
        future: loadAllCommunities(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            //Provider.of<User?>(context)?.reload();
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return AllCommunitiesBody(
              communities: snapshot.data ?? [],
            );
          }

          return const LoadingScaffold();
        }));
  }

  Future<List<Community>> loadAllCommunities() async {
    // TODO later get token from shared pref
    // TODO filter out the communities that the user is part of
    final database = Database();
    await database.fakeToken();

    final response = await database.authorizedApi(Querys.allCommunities);
    List allCommunities = response["data"]["communities"];

    // TODO nextJam from database
    return List<Community>.from(allCommunities.map((com) => Community(
        id: com["id"],
        nextJam: DateTime.now(),
        name: com["name"],
        confirmed: true)));
  }
}
