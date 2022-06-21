import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jams/jams_body.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FutureJams extends StatefulWidget {
  const FutureJams({Key? key, required this.cId}) : super(key: key);

  final String cId;

  @override
  State<FutureJams> createState() => _FutureJamsState();
}

class _FutureJamsState extends State<FutureJams> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries
            .jamsByCommunityId), // this is the query string you just created
        variables: {
          'communityId': widget.cId,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Loading();
        }

        List jams = result.data?['jams'];

        return RefreshIndicator(
          onRefresh: (() async => refetch!()),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: JamsBody(
                jams: jams.map((e) => Jam.fromJson(e)).toList(),
                cId: widget.cId,
              ),
            ),
          ),
        );
      },
    );
  }
}
