import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/home_scaffold.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GetMeQuery extends StatefulWidget {
  const GetMeQuery({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<GetMeQuery> createState() => _GetMeQueryState();
}

class _GetMeQueryState extends State<GetMeQuery> {
  bool isMutationDone = false;
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: Queries.getMe),
      builder: (queryResult, {fetchMore, refetch}) {
        Future<void> runRefetch() async {
          try {
            await refetch!();
          } catch (e) {
            print(e.toString());
          }
        }

        if (queryResult.hasException) {
          return RefreshIndicator(
              onRefresh: () => runRefetch(),
              child: ErrorPage(error: queryResult.exception.toString()));
        } else if (queryResult.data != null && !queryResult.hasException) {
          String? fcmToken = queryResult.data?['me']?[0]?['fcm_token'];
          print("users safed bevore update fcmToken");
          print(fcmToken);
          if (fcmToken == null ||
              fcmToken.isEmpty ||
              fcmToken != widget.token) {
            print("user has no token. Set the new fetched token to the user");
            final updateFcmTokenMutation = useMutation(
              MutationOptions(
                document: Mutations.updateFcmToken,
                onCompleted: (dynamic resultData) {
                  print("resultsdata updatefcmdata");
                  print(resultData);

                  print("completed");
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScaffold(),
                  ));
                  return;
                },
                onError: (error) {
                  print("error in updateFCMtoken");
                  print(error);
                },
              ),
            );
            if (!isMutationDone) {
              updateFcmTokenMutation.runMutation({'fcmToken': widget.token});

              isMutationDone = true;
            }
            return LoadingPage(
              onRefresh: () async => updateFcmTokenMutation
                  .runMutation({'fcmToken': widget.token}),
            );
          } else {
            return HomeScaffold();
          }
        } else {
          return LoadingPage(
            onRefresh: runRefetch,
          );
        }
      },
    );
  }
}
