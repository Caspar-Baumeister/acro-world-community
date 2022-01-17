import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateJam extends StatefulWidget {
  const CreateJam({required this.cid, Key? key}) : super(key: key);
  final String cid;

  @override
  State<CreateJam> createState() => _CreateJamState();
}

class _CreateJamState extends State<CreateJam> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String name = '';
  String location = '';
  String imgUrl = '';
  String date = '';

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.grey[400],
              elevation: 0.0,
              title: const Text('Create a new jam'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'create',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => onCreate(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Name'),
                        validator: (val) =>
                            (val == null || val.isEmpty || val == "")
                                ? 'Enter a valid jam name'
                                : null,
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Location'),
                        validator: (val) =>
                            (val == null || val.isEmpty || val == "")
                                ? 'Enter a valid location'
                                : null,
                        onChanged: (val) {
                          setState(() => location = val);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Image path'),
                        onChanged: (val) {
                          setState(() => imgUrl = val);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'jjjj-mm-dd'),
                        validator: (val) =>
                            (val == null || val.isEmpty || val == "")
                                ? 'Enter a valid date'
                                : null,
                        onChanged: (val) {
                          setState(() => date = val);
                        },
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // triggert when create is pressed
  void onCreate() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      // get activ user to safe the id
      UserModel user =
          Provider.of<UserProvider>(context, listen: false).activeUser!;

      // creates a new jam object
      DataBaseService(uid: user.uid).addJam(
          cid: widget.cid,
          name: name,
          imgUrl: imgUrl,
          location: location,
          date: date);
      // redirects to jams

      setState(() {
        loading = false;
      });
      Navigator.pop(context);

      // error handling
    } else {
      setState(() {
        error = 'Could not sign in with those credentials';
        loading = false;
      });
    }
  }
}
