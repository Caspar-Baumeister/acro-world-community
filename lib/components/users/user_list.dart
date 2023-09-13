import 'package:acroworld/components/acro_role/gender_distribution_pie_from_class_event_id.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/components/spaced_column/spaced_column.dart';
import 'package:acroworld/components/users/user_list_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList(
      {Key? key,
      required this.users,
      this.onScrollEndReached,
      this.classEventId})
      : super(key: key);

  final List<User> users;
  final VoidCallback? onScrollEndReached;
  final String? classEventId;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users found 🤷'),
      );
    } else {
      List<Widget> userListItems = users
          .map(
            (user) => UserListItem(user: user),
          )
          .toList();
      return Column(
        children: [
          SpacedColumn(
            space: 2,
            children: userListItems,
          ),
          classEventId != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GenderDistributionPieFromClassEventId(
                      classEventId: classEventId!),
                )
              : Container()
        ],
      );
    }
  }
}
