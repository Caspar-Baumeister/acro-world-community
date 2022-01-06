import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    String userId = UserIdPreferences.getToken();
    DataBaseService(uid: userId).getUserInfo();
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
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'imgUrl'),
                // validator: (val) => (val == null || val.isEmpty)
                //     ? 'Enter an imgUrl'
                //     : null,
                onChanged: (val) {
                  setState(() => imgUrl = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'userName'),
                // validator: (val) => (val == null || val.length < 6)
                //     ? 'Enter a userName 6+ chars long'
                //     : null,
                onChanged: (val) {
                  setState(() => userName = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[400])),
                  child: const Text(
                    'Änderungen speichern',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState != null) {
                      String uId = UserIdPreferences.getToken();
                      dynamic result = await DataBaseService(uid: uId)
                          .updateUserData(
                              networkImageUrl: imgUrl, userName: userName);
                    }
                  }),
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
