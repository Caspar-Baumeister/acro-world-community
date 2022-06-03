import 'package:acroworld/screens/home/jam/create_jam/date_time_chooser.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateJamBody extends StatefulWidget {
  const CreateJamBody({required this.cid, Key? key}) : super(key: key);
  final String cid;

  @override
  State<CreateJamBody> createState() => _CreateJamBodyState();
}

class _CreateJamBodyState extends State<CreateJamBody> {
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
        ? const Loading()
        : ViewRoot(
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
                              return 'You cannot use more then $maxLenght';
                            }
                            return null;
                          }),
                      Container(
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
          );
  }
}
