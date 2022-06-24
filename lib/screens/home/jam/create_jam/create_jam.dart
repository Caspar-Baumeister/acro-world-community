import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/create_jam/app_bar_create_jam.dart';
import 'package:acroworld/screens/home/jam/create_jam/date_time_chooser.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  bool isLoading = false;

  setDateTime(newDateTime) {
    setState(() {
      _chosenDateTime = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;

    int maxLength = 300;
    return isLoading
        ? const LoadingScaffold()
        : Mutation(
            options: MutationOptions(
              document: Mutations.insertJam,
              onCompleted: (dynamic resultData) {
                setState(() {
                  isLoading = false;
                });
                if (resultData['insert_jams_one'] != null) {
                  Jam createdJam = Jam.fromJson(resultData['insert_jams_one']);
                  eventBus.fire(CrudJamEvent(createdJam));
                  Navigator.pop(context);
                }
              },
              onError: GraphQLErrorHandler().handleError,
            ),
            builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                        {Object? optimisticResult})
                    runMutation,
                QueryResult<dynamic>? result) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBarCreateJam(onCreate: () {
                  if (checkForm()) {
                    setState(() {
                      isLoading = true;
                    });
                    runMutation({
                      "communityId": widget.cid,
                      "name": name,
                      "date": _chosenDateTime.toIso8601String(),
                      "info": info,
                      "latitude": latlng!.latitude,
                      "longitude": latlng!.longitude
                    });
                  }
                }),
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
                            const SizedBox(height: 20.0),
                            DateTimeChooser(
                              chosenDateTime: _chosenDateTime,
                              setDateTime: setDateTime,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autocorrect: true,
                                enableSuggestions: true,
                                decoration:
                                    buildInputDecoration(labelText: 'Info'),
                                onChanged: (val) {
                                  setState(() => info = val);
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty || val == "") {
                                    return 'Provide a short description of the jam';
                                  }
                                  if (val.split(' ').length > maxLength) {
                                    return 'You cannot use more then $maxLength words';
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
            },
          );
  }

  bool checkForm() {
    if (latlng == null) {
      Fluttertoast.showToast(
          msg: "Set a location before creating",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return false;
    }

    return true;
  }
}
