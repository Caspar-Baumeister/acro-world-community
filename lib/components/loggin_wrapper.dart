import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:acroworld/screens/update_fcm_token/update_fcm_token.dart';
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
    final _credentials = await checkCredentials();
    credentials = _credentials;
    return;
  }

  Future<void> _refreshCredentials() async {
    final _credentials = await checkCredentials();
    setState(() {
      credentials = _credentials;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("inside logginwrapper");
    return FutureBuilder(
        future: initCredentials,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(
                error: "loggin_wrapper error: " + snapshot.error.toString());
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
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).refreshToken();
    print("isValidToken");

    print(isValidToken);
    if (!isValidToken) {
      return false;
    }

    await Provider.of<UserProvider>(context, listen: false).setUserFromToken();
    return true;
  }
}
