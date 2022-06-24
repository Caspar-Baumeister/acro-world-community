import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class AppBarJamOverview extends StatefulWidget with PreferredSizeWidget {
  const AppBarJamOverview({required this.jam, Key? key}) : super(key: key);
  final Jam jam;

  @override
  State<AppBarJamOverview> createState() => _AppBarJamOverviewState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarJamOverviewState extends State<AppBarJamOverview> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;
    UserModel user = Provider.of<UserProvider>(context).activeUser!;
    final bool isOwnJam = widget.jam.createdById == user.uid;
    final String jamName = widget.jam.name;
    final String jamId = widget.jam.jid;

    return Mutation(
      options: MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Mutations.deleteJam,
        onError: (OperationException? errorData) {
          String errorMessage = "";
          if (errorData != null) {
            if (errorData.graphqlErrors.isNotEmpty) {
              errorMessage = errorData.graphqlErrors[0].message;
            }
          }
          if (errorMessage == "") {
            errorMessage = "An unknown error occured";
          }
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        onCompleted: (dynamic resultData) {
          print(resultData);
          setState(() {
            isLoading = false;
          });
          if (resultData != null && resultData['affected_rows'] == 1) {
            eventBus.fire(ParticipateToJamEvent(widget.jam.jid));
          }
        },
      ),
      builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                  {Object? optimisticResult})
              runMutation,
          QueryResult<dynamic>? result) {
        return AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: isOwnJam
              ? <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () => {},
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Delete Jam $jamName?'),
                              content: const Text('Are you sure?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    print("Delete Jam $jamId");
                                    runMutation({"jamId": widget.jam.jid});
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('Yes, Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                ]
              : [],
        );
      },
    );
  }
}
