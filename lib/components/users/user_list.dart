import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/components/spaced_column/spaced_column.dart';
import 'package:acroworld/components/users/user_list_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  UserList({Key? key, required this.users, this.onScrollEndReached})
      : super(key: key);

  final List<User> users;
  VoidCallback? onScrollEndReached;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const Center(
        child: Text('No users found 🤷'),
      );
    } else {
      List<Widget> userListItems = widget.users
          .map(
            (user) => UserListItem(user: user),
          )
          .toList();
      return SpacedColumn(
        space: 2,
        children: userListItems,
      );
    }
  }
}