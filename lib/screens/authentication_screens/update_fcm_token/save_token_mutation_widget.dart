import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/home_scaffold.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
          return Query(
            options: QueryOptions(
                document: Queries.getMe, fetchPolicy: FetchPolicy.networkOnly),
            builder: (queryResult, {fetchMore, refetch}) {
              Future<void> runRefetch() async {
                try {
                  await refetch!();
                } catch (e) {
                  print(e.toString());
                }
              }

              if (queryResult.isLoading) {
                return LoadingPage(
                  onRefresh: runRefetch,
                );
              }
              if (queryResult.hasException) {
                return RefreshIndicator(
                    onRefresh: () => runRefetch(),
                    child: ErrorPage(error: queryResult.exception.toString()));
              }

              print('me: ${queryResult.data}');
              String? fcmToken = queryResult.data?['me']?[0]?['fcm_token'];
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
