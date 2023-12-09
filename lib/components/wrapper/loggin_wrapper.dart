import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/authentication_screens/update_fcm_token/update_fcm_token.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
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
  bool? credentials;
  Future<void>? initCredentials;

  @override
  void initState() {
    super.initState();
    initCredentials = _initCredentials();
  }

  Future<void> _initCredentials() async {
    final newCredentials = await checkCredentials();
    credentials = newCredentials;
    return;
  }

  Future<void> _refreshCredentials() async {
    final newCredentials = await checkCredentials();
    setState(() {
      credentials = newCredentials;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_LogginWrapperState:build');
    return FutureBuilder(
        future: initCredentials,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(error: "loggin_wrapper error: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.done &&
              credentials != null) {
            if (credentials == false) {
              return const Authenticate();
            } else {
              return const UpdateFcmToken();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(onRefresh: _refreshCredentials);
          } else {
            return ErrorPage(
                error:
                    "connectionState: ${snapshot.connectionState.toString()}");
          }
        }));
  }

  Future<bool> checkCredentials() async {
    // gets the current token and if therer is none, tries to login with shared preference safed credentials
    bool isValidToken = await Provider.of<UserProvider>(context, listen: false)
        .refreshTokenFunction();
    print('isValidToken $isValidToken');
    return isValidToken;
  }
}
