import 'package:acroworld/components/standard_app_bar/standard_app_bar.dart';
import 'package:acroworld/components/users/user_list_query.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';

class QueryUserListScreen extends StatelessWidget {
  const QueryUserListScreen(
      {Key? key, required this.query, required this.variables, this.title})
      : super(key: key);

  final DocumentNode query;
  final Map<String, dynamic> variables;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StandardAppBar(title: title ?? 'Users'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UserListQuery(query: query, variables: variables),
      ),
    );
  }
}
