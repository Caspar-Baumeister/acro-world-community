import 'package:acroworld/screens/home/communities/all_communities/all_communities.dart';

import 'package:flutter/material.dart';

class NewCommunityButton extends StatelessWidget {
  const NewCommunityButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AllCommunities()),
              ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          )),
    );
  }
}
