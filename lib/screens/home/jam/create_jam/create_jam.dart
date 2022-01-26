import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/create_jam/app_bar_create_jam.dart';
import 'package:acroworld/screens/home/jam/create_jam/date_time_chooser.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateJam extends StatefulWidget {
  const CreateJam({required this.cid, Key? key}) : super(key: key);
  final String cid;

  @override
  State<CreateJam> createState() => _CreateJamState();
}

class _CreateJamState extends State<CreateJam> {
  DateTime _chosenDateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String name = '';
  String location = '';
  String imgUrl = '';
  String info = '';

  setDateTime(newDateTime) {
    setState(() {
      _chosenDateTime = newDateTime;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarCreateJam(onCreate: onCreate),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              decoration:
                                  buildInputDecoration(labelText: 'Image path'),
                              onChanged: (val) {
                                setState(() => imgUrl = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration:
                                  buildInputDecoration(labelText: 'Name'),
                              validator: (val) =>
                                  (val == null || val.isEmpty || val == "")
                                      ? 'Enter a valid jam name'
                                      : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: TextFormField(
                              keyboardType: TextInputType.streetAddress,
                              decoration:
                                  buildInputDecoration(labelText: 'Location'),
                              validator: (val) =>
                                  (val == null || val.isEmpty || val == "")
                                      ? 'Enter a valid location'
                                      : null,
                              onChanged: (val) {
                                setState(() => location = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          DateTimeChooser(
                            chosenDateTime: _chosenDateTime,
                            setDateTime: setDateTime,
                          ),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: TextFormField(
                              maxLines: 10,
                              keyboardType: TextInputType.text,
                              decoration:
                                  buildInputDecoration(labelText: 'Info'),
                              onChanged: (val) {
                                setState(() => info = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          date: _chosenDateTime);
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
