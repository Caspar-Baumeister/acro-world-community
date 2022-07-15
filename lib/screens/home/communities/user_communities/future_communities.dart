import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/user_communities/body.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureCommunity extends StatelessWidget {
  const FutureCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: loadUserCommunities(context),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return const UserCommunitiesBody();
          }

          return const LoadingScaffold();
        }));
  }

  Future<bool> loadUserCommunities(BuildContext context) async {
    // validates that the user is loged in and the token is valid
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return false;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;

    // updates the user communities in provider
    await Provider.of<UserCommunitiesProvider>(context, listen: false)
        .loadData(token);
    return true;
  }
}
