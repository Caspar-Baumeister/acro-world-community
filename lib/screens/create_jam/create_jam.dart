import 'package:acroworld/components/map.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/chatroom/widgets/time_bubble.dart';
import 'package:acroworld/screens/create_jam/app_bar_create_jam.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:acroworld/components/view_root.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CreateJam extends StatefulWidget {
  const CreateJam(
      {required this.cid,
      Key? key,
      this.jam,
      required this.community,
      this.initialDate})
      : super(key: key);
  final String cid;
  final Community? community;
  final Jam? jam;
  final DateTime? initialDate;

  @override
  State<CreateJam> createState() => _CreateJamState();
}

class _CreateJamState extends State<CreateJam> {
  DateTime _chosenDateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String info = '';
  LatLng? latlng;

  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _chosenDateTime = widget.initialDate!;
    }
    if (widget.jam != null) {
      Jam jam = widget.jam!;
      isEdit = true;
      setState(() {
        _chosenDateTime = jam.date!;
        name = jam.name ?? "";
        info = jam.info ?? "";
        latlng = jam.latLng;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;

    int maxLength = 300;
    return isLoading
        ? const LoadingPage()
        : Mutation(
            options: MutationOptions(
              document: isEdit ? Mutations.updateJam : Mutations.insertJam,
              onCompleted: (dynamic resultData) {
                setState(() {
                  isLoading = false;
                });
                if (resultData != null) {
                  dynamic returnedJamObject = isEdit
                      ? resultData['update_jams_by_pk']
                      : resultData['insert_jams_one'];

                  if (returnedJamObject != null) {
                    Jam createdJam = Jam.fromJson(returnedJamObject);
                    eventBus.fire(CrudJamEvent(createdJam));
                    Navigator.pop(context);
                  }
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
                appBar: AppBarJam(
                    title: isEdit ? 'Edit Jam' : 'Create Jam',
                    onSubmit: () {
                      if (checkForm()) {
                        setState(() {
                          isLoading = true;
                        });
                        print("inside onSubmit");
                        print(_chosenDateTime.toIso8601String());
                        if (isEdit) {
                          runMutation({
                            "jamId": widget.jam!.jid,
                            "name": name,
                            "date": _chosenDateTime.toIso8601String(),
                            "info": info,
                            "latitude": latlng!.latitude,
                            "longitude": latlng!.longitude
                          });
                        } else {
                          runMutation({
                            "communityId": widget.cid,
                            "name": name,
                            "date": _chosenDateTime.toIso8601String(),
                            "info": info,
                            "latitude": latlng!.latitude,
                            "longitude": latlng!.longitude
                          });
                        }
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
                              initialValue: name,
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
                            GestureDetector(
                                onTap: () => _showDatePicker(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // constraints: const BoxConstraints(maxWidth: 250),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    readableTimeString(
                                        _chosenDateTime.toString()),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ),
                                )),
                            const SizedBox(height: 20.0),
                            TextFormField(
                                initialValue: info,
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
                                minLines: 3,
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
                                zoom: 11.0,
                                center: widget.jam?.latLng != null
                                    ? widget.jam!.latLng
                                    : widget.community!.latLng,
                                markerLocation: latlng,
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

  void _showDatePicker(ctx) {
    final date = DateTime.now();
    var val = date;
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(70)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    height: 400,
                    child: CupertinoDatePicker(
                        //use24hFormat: true,
                        minimumDate: date,
                        maximumDate:
                            DateTime(date.year, date.month + 1, date.day),
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime val) => setState(() {
                              _chosenDateTime = val;
                            })),
                  ),
                ],
              ),
            ));
  }

  bool checkForm() {
    if (latlng == null) {
      Fluttertoast.showToast(
          msg: "Set a location before creating",
          toastLength: Toast.LENGTH_LONG,
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
