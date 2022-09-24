import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:acroworld/widgets/users/user_list_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  UserList({Key? key, required this.users, this.onScrollEndReached})
      : super(key: key);

  final List<User> users;
  final ScrollController scrollController = ScrollController();
  VoidCallback? onScrollEndReached;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset ==
          widget.scrollController.position.maxScrollExtent) {
        if (widget.onScrollEndReached != null) {
          widget.onScrollEndReached!();
        }
      }
    });
    if (widget.users.isEmpty) {
      return const Center(
        child: Text('No useres found 🤷'),
      );
    } else {
      List<Widget> userListItems = widget.users
          .map(
            (user) => UserListItem(user: user),
          )
          .toList();
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: SpacedColumn(
          space: 2,
          children: userListItems,
        ),
      );
    }
  }
}
