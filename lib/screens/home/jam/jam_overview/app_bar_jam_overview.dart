import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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
    User user = Provider.of<UserProvider>(context).activeUser!;
    final bool isOwnJam = widget.jam.createdById == user.id;
    final String jamName = widget.jam.name;
    final String jamId = widget.jam.jid;

    return Mutation(
      options: MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Mutations.deleteJam,
        onError: GraphQLErrorHandler().handleError,
        onCompleted: (dynamic resultData) {
          setState(() {
            isLoading = false;
          });
          if (resultData != null &&
              resultData['delete_jams']['affected_rows'] == 1) {
            eventBus.fire(CrudJamEvent(widget.jam));
            Navigator.pop(context);
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
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateJam(
                                  cid: widget.jam.communityId,
                                  community: widget.jam.community,
                                  jam: widget.jam,
                                )),
                      )
                    },
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
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
