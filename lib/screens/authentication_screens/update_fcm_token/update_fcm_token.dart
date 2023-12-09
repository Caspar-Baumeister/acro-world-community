import 'package:acroworld/screens/authentication_screens/update_fcm_token/save_token_mutation_widget.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// This widget is always run when the user loggs in or registered or restarts the app (automatically relogin)
// The widget has a futerbuilder, where it fetches the token and as
// soon as this is finished, gives the token to the next widget
// where it will be compared against the current fcm token of the user

class UpdateFcmToken extends StatefulWidget {
  const UpdateFcmToken({Key? key}) : super(key: key);

  @override
  State<UpdateFcmToken> createState() => _UpdateFcmTokenState();
}

class _UpdateFcmTokenState extends State<UpdateFcmToken> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? token;
  Future<bool>? initialTokenLoaded;

  @override
  void initState() {
    super.initState();
    initialTokenLoaded = _initToken();
  }

  Future<bool> _initToken() async {
    print("_initToken newToken");
    final newToken = await FirebaseMessaging.instance.getToken();
    token = newToken;
    print(newToken);
    return newToken != null ? true : false;
  }

  Future<void> _refreshToken() async {
    print("_refreshToken newToken");
    final newToken = await FirebaseMessaging.instance.getToken();
    print(newToken);
    setState(() {
      token = newToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_UpdateFcmTokenState:build');
    return FutureBuilder<bool>(
      future: initialTokenLoaded,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshToken,
            child: ErrorPage(
              error: snapshot.error.toString(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true && token != null) {
          return SaveTokenMutationWidget(
            token: token!,
          );
        } else {
          return LoadingPage(
            onRefresh: _refreshToken,
          );
        }
      }),
    );
  }
}
