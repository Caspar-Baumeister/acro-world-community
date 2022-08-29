import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/user_communities/user_communities.dart';
import 'package:acroworld/shared/widgets/loading_indicator/loading_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateFcmToken extends StatefulWidget {
  UpdateFcmToken({Key? key}) : super(key: key);

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
            return const UserCommunities();
          } else if (!snapshot.hasData) {
            return const LoadingIndicator();
          } else {
            final currentFcmToken = snapshot.data;
            return Mutation(
              options: MutationOptions(document: Mutations.updateFcmToken),
              builder: (runMutation, mutationResult) {
                if (mutationResult == null || mutationResult.isLoading) {
                  return const LoadingIndicator();
                }

                if (mutationResult.hasException) {
                  return const UserCommunities();
                }

                if (mutationResult.data != null) {
                  // FCM Token was updated
                  return const UserCommunities();
                } else {
                  return Query(
                    options: QueryOptions(document: Queries.getMe),
                    builder: (queryResult, {fetchMore, refetch}) {
                      if (queryResult.isLoading) {
                        return const LoadingIndicator();
                      }

                      String? fcmToken =
                          queryResult.data?['me'][0]['fcm_token'];
                      if (fcmToken == null ||
                          fcmToken.isEmpty ||
                          fcmToken != currentFcmToken) {
                        runMutation({'fcmToken': currentFcmToken});
                        return Container();
                      } else {
                        return const UserCommunities();
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
