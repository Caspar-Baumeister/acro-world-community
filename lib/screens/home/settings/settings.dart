import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/settings/widgets/profile_picture.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool initialized = false;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String imgUrl = '';
  String userName = '';
  String userBio = '';

  @override
  Widget build(BuildContext context) {
    // final String uid = Provider.of<User?>(context)!.uid;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DataBaseService database =
        DataBaseService(uid: userProvider.activeUser!.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const ProfilePicture(),

                //isnt used because of mainaxis size max
                const SizedBox(height: 24.0),
                // Text(userProvider.activeUser!.userName ?? "no username",
                //     style: const TextStyle(fontSize: 16)),
                // //isnt used because of mainaxis size max
                // const SizedBox(height: 12.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: buildInputDecoration(
                          labelText: userProvider.activeUser!.userName ??
                              "new username"),
                      // validator: (val) => (val == null || val.length < 6)
                      //     ? 'Enter a userName 6+ chars long'
                      //     : null,
                      onChanged: (val) {
                        setState(() => userName = val);
                      },
                    ),
                    //isnt used because of mainaxis size max
                    const SizedBox(height: 20.0),
                    TextFormField(
                      maxLines: 10,
                      decoration: buildInputDecoration(
                          labelText:
                              userProvider.activeUser!.bio ?? 'Your bio'),
                      // validator: (val) => (val == null || val.length < 6)
                      //     ? 'Enter a userName 6+ chars long'
                      //     : null,
                      onChanged: (val) {
                        setState(() => userBio = val);
                      },
                    ),
                    //isnt used because of mainaxis size max
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side:
                                        const BorderSide(color: Colors.grey)))),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          updateUserData(database, userProvider);
                        }),
                  ],
                ),
                //isnt used because of mainaxis size max
                const SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateUserData(database, userProvider) {
    if (_formKey.currentState != null) {
      //bool updated = false;
      if (userName != "") {
        database.updateUserDataField(field: "userName", value: userName);
        UserModel user = userProvider.activeUser!;
        user.userName = userName;
        userProvider.activeUser = user;
        //updated = true;
      }
      if (userBio != "") {
        database.updateUserDataField(field: "bio", value: userBio);
        UserModel user = userProvider.activeUser!;
        user.bio = userBio;
        userProvider.activeUser = user;
        //updated = true;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Yay! A SnackBar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
    }
  }
}
