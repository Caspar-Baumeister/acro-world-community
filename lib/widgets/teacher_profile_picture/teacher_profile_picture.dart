import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherProfilePicture extends StatelessWidget {
  const TeacherProfilePicture(
      {Key? key, required this.teacherId, required this.url})
      : super(key: key);

  final String teacherId;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: Mutations.updateLastVisetedAt,
          onError: GraphQLErrorHandler().handleError,
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          return Container();
        });
  }
}
