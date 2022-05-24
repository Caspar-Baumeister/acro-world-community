import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/modals/set_community_picture.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/message_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewCommunityModal extends StatefulWidget {
  const CreateNewCommunityModal({Key? key}) : super(key: key);

  @override
  State<CreateNewCommunityModal> createState() =>
      _CreateNewCommunityModalState();
}

class _CreateNewCommunityModalState extends State<CreateNewCommunityModal> {
  String error = "";
  String name = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
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
              "Suggest a new community",
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
            error != ""
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : Container(),
            const SizedBox(height: 30.0),

            IgnorePointer(
              ignoring: loading,
              child: ElevatedButton(
                child: const Text(
                  "Suggest community",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => suggestCommunity(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                  primary: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  suggestCommunity() async {
    // check if name is empty
    if (name == "") {
      setState(() {
        error = "Provide a valid name";
      });
      return;
    }

    // loading for databse tasks
    setState(() {
      loading = true;
      error = "";
    });

    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return null;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    final database = Database(token: token);

    final response = await database.createCommunity(name);
    print(response);

    Navigator.of(context).pop();
    buildMortal(
        context,
        MessageModal(
            message:
                "You successfully suggested the community $name. It can take a while until we reviewed it"));

    setState(() {
      loading = false;
    });
  }
}
