import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:acroworld/widgets/users/user_list_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> userListItems =
        widget.users.map((user) => UserListItem(user: user)).toList();
    return SingleChildScrollView(
      child: SpacedColumn(space: 2, children: userListItems),
    );
  }
}
