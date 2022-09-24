import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/users/user_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class UserListQuery extends StatelessWidget {
  UserListQuery({Key? key, required this.query, required this.variables})
      : super(key: key);

  final DocumentNode query;
  final Map<String, dynamic> variables;
  List<User> users = [];

  int limit = 20;
  int offset = 0;

  List<User> parseResultData(dynamic resultData) {
    return List<User>.from(
      resultData['users'].map(
        (userJson) => User.fromJson(userJson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    variables['limit'] = limit;
    variables['offset'] = offset;
    return Query(
      options: QueryOptions(
        document: query,
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        //Initial loading
        if (result.isLoading && result.data == null) {
          return const Loading();
        }
        if (result.data != null) {
          users.addAll(parseResultData(result.data!));
          return UserList(
            users: users,
            onScrollEndReached: () {
              print('onScrollEndReached');
              variables['offset'] = variables['offset'] + limit;
              print(fetchMore);
              fetchMore!(FetchMoreOptions.partial(
                  variables: variables,
                  updateQuery: (Map<String, dynamic>? previousResultData,
                      Map<String, dynamic>? fetchMoreResultData) {
                    return {};
                  }));
            },
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
