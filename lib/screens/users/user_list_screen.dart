import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/widgets/standard_app_bar/standard_app_bar.dart';
import 'package:acroworld/widgets/users/user_list_query.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';

class QueryUserListScreen extends StatelessWidget {
  const QueryUserListScreen(
      {Key? key, required this.query, required this.variables})
      : super(key: key);

  final DocumentNode query;
  final Map<String, dynamic> variables;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StandardAppBar(title: 'Users'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UserListQuery(query: query, variables: variables),
      ),
    );
  }
}
