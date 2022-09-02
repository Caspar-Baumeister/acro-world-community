import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/screens/home/communities/modals/set_community_picture.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/shared/message_modal.dart';
import 'package:acroworld/shared/widgets/location_search/location_search.dart';
import 'package:acroworld/widgets/headers/h2.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Error extends StatelessWidget {
  const Error({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text != "") {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          text,
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return Container();
    }
  }
}

class SuggestNewCommunity extends StatefulWidget {
  const SuggestNewCommunity({Key? key}) : super(key: key);

  @override
  State<SuggestNewCommunity> createState() => _SuggestNewCommunityState();
}

class _SuggestNewCommunityState extends State<SuggestNewCommunity> {
  String nameError = "";
  String name = "";
  String locationError = "";
  LatLng? location;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Mutation(
        options: MutationOptions(document: Mutations.insertCommunity),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result != null) {
            if (result.isLoading) {
              return const Loading();
            }
            if (result.data?['insert_communities_one'] != null) {
              {
                Navigator.of(context).pop();
                Future.delayed(Duration.zero, () {
                  buildMortal(
                      context,
                      MessageModal(
                          message:
                              "You successfully suggested the community $name. It can take a while until we reviewed it"));
                });
              }
            }
          }

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            width: double.infinity,
            child: SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                space: 8,
                children: [
                  const SetCommunityPicture(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const H2(text: "Name"),
                  ),
                  SizedBox(
                    child: TextField(
                        decoration: buildInputDecoration(labelText: "Name"),
                        onChanged: (val) => setState(() {
                              name = val;
                            })),
                  ),
                  Error(text: nameError),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const H2(text: "Location"),
                  ),
                  LocationSearch(onPlaceSet: (place) {
                    location = place.latLng;
                  }),
                  Error(text: locationError),
                  IgnorePointer(
                    ignoring: loading,
                    child: ElevatedButton(
                      child: const Text(
                        "Suggest community",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => {
                        if (checkFields())
                          {
                            runMutation({
                              'name': name,
                              'latitude': location!.latitude,
                              'longitude': location!.longitude
                            })
                          }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12.0),
                        primary: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }

  bool checkFields() {
    if (name == "") {
      setState(() {
        nameError = "Provide a valid name";
      });
      return false;
    }

    if (location == null) {
      setState(() {
        locationError = "Please choose a location";
      });
      return false;
    }
    return true;
  }
}
