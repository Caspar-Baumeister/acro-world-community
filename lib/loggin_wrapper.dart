import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/user_communities/user_communities.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogginWrapper extends StatefulWidget {
  const LogginWrapper({Key? key}) : super(key: key);

  // checkes if there are credentials
  // sends a login request with the credentials
  // updates the user provider or sends to login

  @override
  State<LogginWrapper> createState() => _LogginWrapperState();
}

class _LogginWrapperState extends State<LogginWrapper> {
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkCredentials(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (snapshot.data == false) {
              return const Authenticate();
            } else {
              return const UserCommunities();
            }
          }

          return const LoadingScaffold();
        }));
  }

  Future<bool> checkCredentials() async {
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).refreshToken();

    if (!isValidToken) {
      return false;
    }

    await Provider.of<UserProvider>(context, listen: false).setUserFromToken();
    return true;
  }
}
