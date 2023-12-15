import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/home_scaffold.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class SaveTokenMutationWidget extends StatefulWidget {
  const SaveTokenMutationWidget({Key? key, required this.token})
      : super(key: key);
  final String token;

  @override
  State<SaveTokenMutationWidget> createState() =>
      _SaveTokenMutationWidgetState();
}

class _SaveTokenMutationWidgetState extends State<SaveTokenMutationWidget> {
  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(document: Mutations.updateFcmToken),
      builder: (RunMutation runMutation, mutationResult) {
        if (mutationResult != null && mutationResult.isLoading) {
          return LoadingPage(
            onRefresh: () async => runMutation({'fcmToken': widget.token}),
          );
        }
        if (mutationResult != null && mutationResult.hasException) {
          return ErrorPage(error: mutationResult.exception.toString());
        }

        if (mutationResult != null && mutationResult.data != null) {
          // FCM Token was updated
          return const HomeScaffold();
        } else {
          return Consumer<UserProvider>(
            builder: (context, provider, child) {
              String? fcmToken = provider.activeUser?.fcmToken;
              if (fcmToken == null ||
                  fcmToken.isEmpty ||
                  fcmToken != widget.token) {
                runMutation({'fcmToken': widget.token});
                return LoadingPage(
                  onRefresh: () async =>
                      runMutation({'fcmToken': widget.token}),
                );
              } else {
                return const HomeScaffold();
              }
            },
          );
        }
      },
    );
  }
}
