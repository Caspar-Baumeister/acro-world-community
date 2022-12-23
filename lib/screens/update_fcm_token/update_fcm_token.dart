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
    final _token = await FirebaseMessaging.instance.getToken();
    token = _token;
    return _token != null ? true : false;
  }

  Future<void> _refreshToken() async {
    final _token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = _token;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          print("fetched token succesfully: $token");
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
              Future<void> runRefetch() async {
                try {
                  refetch!();
                } catch (e) {
                  print(e.toString());
                }
              }

              if (queryResult.isLoading) {
                return LoadingPage(
                  onRefresh: runRefetch,
                );
              }

              String? fcmToken = queryResult.data?['me'][0]['fcm_token'];
              if (fcmToken == null ||
                  fcmToken.isEmpty ||
                  fcmToken != widget.token) {
                runMutation({'fcmToken': widget.token});
                return LoadingPage(
                  onRefresh: () async =>
                      runMutation({'fcmToken': widget.token}),
                );
              } else {
                return HomeScaffold();
              }
            },
          );
        }
      },
    );
  }
}

class GetMeQuery extends StatefulWidget {
  const GetMeQuery({Key? key}) : super(key: key);

  @override
  State<GetMeQuery> createState() => _GetMeQueryState();
}

class _GetMeQueryState extends State<GetMeQuery> {
//   final addStarMutation = useMutation(
//   MutationOptions(
//     document: gql(addStar), // this is the mutation string you just created
//     // you can update the cache based on results
//     update: (GraphQLDataProxy cache, QueryResult result) {
//       return cache;
//     },
//     // or do something with the result.data on completion
//     onCompleted: (dynamic resultData) {
//       print(resultData);
//     },
//   ),
// );

// runMutation({'fcmToken': widget.token});
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: Queries.getMe),
      builder: (queryResult, {fetchMore, refetch}) {
        Future<void> runRefetch() async {
          try {
            refetch!();
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
          if (fcmToken == null || fcmToken.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => runRefetch(),
              child: const LoadingPage(),
            );
          } else {
            return HomeScaffold();
          }
        } else {
          return RefreshIndicator(
            onRefresh: () => runRefetch(),
            child: const LoadingPage(),
          );
        }
      },
    );
  }
}
