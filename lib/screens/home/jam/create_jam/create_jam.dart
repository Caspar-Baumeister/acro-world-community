import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/jam/create_jam/app_bar_create_jam.dart';
import 'package:acroworld/screens/home/jam/create_jam/date_time_chooser.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CreateJam extends StatefulWidget {
  const CreateJam({required this.cid, Key? key, required this.refreshState})
      : super(key: key);
  final String cid;
  final VoidCallback refreshState;

  @override
  State<CreateJam> createState() => _CreateJamState();
}

class _CreateJamState extends State<CreateJam> {
  DateTime _chosenDateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String location = '';
  String imgUrl = '';
  String info = '';
  LatLng? latlng;

  setDateTime(newDateTime) {
    setState(() {
      _chosenDateTime = newDateTime;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    int maxLenght = 30;
    return loading
        ? const LoadingScaffold()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarCreateJam(onCreate: () => onCreate()),
            body: ViewRoot(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: buildInputDecoration(labelText: 'Name'),
                          validator: (val) =>
                              (val == null || val.isEmpty || val == "")
                                  ? 'Enter a valid jam name'
                                  : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        DateTimeChooser(
                          chosenDateTime: _chosenDateTime,
                          setDateTime: setDateTime,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: true,
                            enableSuggestions: true,
                            decoration: buildInputDecoration(labelText: 'Info'),
                            onChanged: (val) {
                              setState(() => info = val);
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty || val == "") {
                                return 'Provide a short description of the jam';
                              }
                              if (val.split(' ').length > maxLenght) {
                                return 'You cannot use more then $maxLenght words';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          constraints: const BoxConstraints(maxHeight: 350),
                          child: MapWidget(
                            onLocationSelected: (location) =>
                                {setState(() => latlng = location)},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  // triggert when create is pressed
  void onCreate() async {
    if (latlng == null) {
      Fluttertoast.showToast(
          msg: "Set a location before creating",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
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
    final response = await database.insertJam(widget.cid, name,
        _chosenDateTime.toIso8601String(), latlng!.latitude, latlng!.longitude);

    print("create jam response: $response");
    widget.refreshState();
    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }
}
