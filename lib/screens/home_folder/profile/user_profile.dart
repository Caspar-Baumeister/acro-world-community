import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/components/view_root.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({required this.user, Key? key}) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return ViewRoot(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // CircleAvatar(
            //     radius: 100.0, backgroundImage: NetworkImage(user.imgUrl)),

            //isnt used because of mainaxis size max
            const SizedBox(height: 24.0),
            Text(user.name ?? "Unknown", style: const TextStyle(fontSize: 16)),
            //isnt used because of mainaxis size max
            // const SizedBox(height: 12.0),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   alignment: Alignment.centerLeft,
            //   child: Text(user.bio,
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(fontSize: 16)),
            // ),
            // Column(
            //   children: user.communities!.map((com) => Text(com.id)).toList(),
            // ),
          ],
        ),
      ),
    );
  }
}
