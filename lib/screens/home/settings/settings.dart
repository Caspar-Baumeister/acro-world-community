import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    // final String uid = Provider.of<User?>(context)!.uid;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DataBaseService database =
        DataBaseService(uid: userProvider.activeUser!.uid);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[400],
      //   elevation: 0.0,
      //   title: const Text('Register for Acro World'),
      //   actions: <Widget>[
      //     TextButton.icon(
      //       icon: const Icon(
      //         Icons.person,
      //         color: Colors.black,
      //       ),
      //       label: const Text(
      //         'Sign In',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //       onPressed: () => widget.toggleView(),
      //     ),
      //   ],
      // ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      userProvider.activeUser!.imgUrl ?? MORTY_IMG_URL)),
              //isnt used because of mainaxis size max
              const SizedBox(width: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'image path'),
                      // validator: (val) => (val == null || val.isEmpty)
                      //     ? 'Enter an imgUrl'
                      //     : null,
                      onChanged: (val) {
                        setState(() => imgUrl = val);
                      },
                    ),
                  ),
                  //isnt used because of mainaxis size max
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[400])),
                      child: const Text(
                        'safe',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState != null) {
                          database.updateUserDataField(
                              field: "imgUrl", value: imgUrl);
                          UserModel user = userProvider.activeUser!;
                          user.imgUrl = imgUrl;
                          userProvider.activeUser = user;
                        }
                      }),
                ],
              ),
              //isnt used because of mainaxis size max
              const SizedBox(height: 12.0),
              Text(userProvider.activeUser!.userName ?? "no username",
                  style: const TextStyle(fontSize: 16)),
              //isnt used because of mainaxis size max
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'new username'),
                      // validator: (val) => (val == null || val.length < 6)
                      //     ? 'Enter a userName 6+ chars long'
                      //     : null,
                      onChanged: (val) {
                        setState(() => userName = val);
                      },
                    ),
                  ),
                  //isnt used because of mainaxis size max
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[400])),
                      child: const Text(
                        'safe',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState != null) {
                          database.updateUserDataField(
                              field: "userName", value: userName);
                          UserModel user = userProvider.activeUser!;
                          user.userName = userName;
                          userProvider.activeUser = user;
                        }
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
    );
  }
}
