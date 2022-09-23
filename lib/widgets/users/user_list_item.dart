import 'package:acroworld/models/user_model.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(user.imageUrl ?? ''),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(user.name!),
      ],
    );
  }
}
