import 'package:acroworld/screens/home/communities/modals/set_community_picture.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:flutter/material.dart';

class CreateNewCommunityModal extends StatefulWidget {
  const CreateNewCommunityModal({Key? key}) : super(key: key);

  @override
  State<CreateNewCommunityModal> createState() =>
      _CreateNewCommunityModalState();
}

class _CreateNewCommunityModalState extends State<CreateNewCommunityModal> {
  @override
  Widget build(BuildContext context) {
    String name = "";
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 24.0),
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // header devider
            const Divider(
              color: Colors.black,
              thickness: 2.0,
              indent: double.infinity * 0.43,
              endIndent: double.infinity * 0.43,
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Create a new community",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30.0),
            const SetCommunityPicture(),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 200,
              child: TextField(
                  decoration: buildInputDecoration(labelText: "Name"),
                  onChanged: (val) => setState(() {
                        name = val;
                      })),
            ),
            const SizedBox(height: 30.0),

            ElevatedButton(
              child: const Text(
                "Suggest community",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
                primary: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            )
          ]),
    );
  }
}
