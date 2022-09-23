import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/users/user_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class UserListQuery extends StatelessWidget {
  const UserListQuery({Key? key, required this.query, required this.variables})
      : super(key: key);

  final DocumentNode query;
  final Map<String, dynamic> variables;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: query,
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return const Loading();
        }
        if (result.data != null) {
          List<dynamic> usersResult = result.data!['users'];
          List<User> users;
          if (usersResult.isNotEmpty) {
            users = List<User>.from(
              result.data!['users'].map(
                (userJson) => User.fromJson(userJson),
              ),
            );
          } else {
            users = [];
          }
          return UserList(users: users);
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
