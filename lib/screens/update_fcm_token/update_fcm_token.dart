import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/screens/home_screens/home_scaffold.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateFcmToken extends StatefulWidget {
  const UpdateFcmToken({Key? key}) : super(key: key);

  @override
  State<UpdateFcmToken> createState() => _UpdateFcmTokenState();
}

class _UpdateFcmTokenState extends State<UpdateFcmToken> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: FirebaseMessaging.instance.getToken(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(
              error: snapshot.error.toString(),
            );
          } else if (!snapshot.hasData) {
            // TODO REFRESH WIDGET
            return const LoadingPage();
          } else {
            final currentFcmToken = snapshot.data;
            return Mutation(
              options: MutationOptions(document: Mutations.updateFcmToken),
              builder: (runMutation, mutationResult) {
                if (mutationResult == null || mutationResult.isLoading) {
                  return const LoadingPage();
                }

                if (mutationResult.hasException) {
                  return ErrorPage(error: mutationResult.exception.toString());
                }

                if (mutationResult.data != null) {
                  // FCM Token was updated
                  return HomeScaffold();
                } else {
                  return Query(
                    options: QueryOptions(document: Queries.getMe),
                    builder: (queryResult, {fetchMore, refetch}) {
                      if (queryResult.isLoading) {
                        return const LoadingPage();
                      }

                      String? fcmToken =
                          queryResult.data?['me'][0]['fcm_token'];
                      if (fcmToken == null ||
                          fcmToken.isEmpty ||
                          fcmToken != currentFcmToken) {
                        runMutation({'fcmToken': currentFcmToken});
                        return const LoadingPage();
                      } else {
                        return HomeScaffold();
                      }
                    },
                  );
                }
              },
            );
          }
        }));
  }
}
