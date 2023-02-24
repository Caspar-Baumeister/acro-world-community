import 'package:acroworld/screens/add_communities/all_communities/all_communities.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';

import 'package:flutter/material.dart';

class NewCommunityButton extends StatelessWidget {
  const NewCommunityButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AllCommunities()),
        ),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: BUTTON_FILL_COLOR),
              borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
            ),
            width: 50,
            height: 40,
            child: const Center(
                child: Icon(
              Icons.add,
              color: Colors.black,
            ))),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 4),
    //   child: OutlinedButton(
    //       style: OutlinedButton.styleFrom(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
    //         ),
    //       ),
    //       onPressed: () => Navigator.of(context).push(
    //             MaterialPageRoute(builder: (context) => const AllCommunities()),
    //           ),
    //       child: const Icon(
    //         Icons.add,
    //         color: Colors.black,
    //       )),
    // );
  }
}
