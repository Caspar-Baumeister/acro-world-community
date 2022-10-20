// before this screen there has to be another widgets that pulls the data from the database
// here i pretend the data ist there
// data: all jams from the user with time from all usercommunities

import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/calender/app_bar_calendar.dart';
import 'package:acroworld/screens/home/calender/future_calender_jams.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Calender extends StatelessWidget {
  const Calender({Key? key}) : super(key: key);

  //final List<Jam> userJams = DataClass().jams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCalendar(),
      body: const FutureCalenderJams(),
      floatingActionButton: floatingActionButton(context),
    );
  }
}

Widget floatingActionButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () => buildMortal(context, const SimpleUserCommunityQuery()),
      child: const Text(
        "Plan a jam",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
  );
}

class SimpleUserCommunityQuery extends StatelessWidget {
  const SimpleUserCommunityQuery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.getUserCommunities,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Container();
          }

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          });
          List<Community> communities = [];

          if (result.data != null && result.data?['me'].length > 0) {
            communities.addAll(List<Community>.from(
                result.data?['me']?[0]?['communities'].map((userCommunity) {
              dynamic messageJson;
              if (userCommunity['community']["community_messages"].isNotEmpty) {
                messageJson =
                    userCommunity['community']["community_messages"][0];
              }

              return Community.fromJson(
                userCommunity['community'],
                lastVisitedAt: userCommunity["last_visited_at"],
                messageJson: messageJson,
                // nextJamAt: date
              );
            })));
          }

          return ChooseCommunityModal(communities: communities);
        });
  }
}

class ChooseCommunityModal extends StatefulWidget {
  const ChooseCommunityModal({Key? key, required this.communities})
      : super(key: key);

  final List<Community> communities;

  @override
  State<ChooseCommunityModal> createState() => _ChooseCommunityModalState();
}

class _ChooseCommunityModalState extends State<ChooseCommunityModal> {
  late String? dropdownValue;
  late Community? choosenCommunity;

  @override
  void initState() {
    if (widget.communities.isNotEmpty) {
      choosenCommunity = widget.communities[0];
      dropdownValue = widget.communities[0].id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> communitiesDropdown = [];
    for (var community in widget.communities) {
      communitiesDropdown.add(DropdownMenuItem<String>(
          key: Key(community.id),
          value: community.id,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Text(
              community.name,
              maxLines: 2,
            ),
          )));
    }
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.all(20),
      height: 400,
      child: widget.communities.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select the community in which you want to create a jam",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: DropdownButton(
                      value: dropdownValue,
                      items: communitiesDropdown,
                      onChanged: (value) {
                        setState(() {
                          choosenCommunity = widget.communities
                              .firstWhere((element) => element.id == value);
                          dropdownValue = choosenCommunity!.id;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => choosenCommunity != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateJam(
                                  cid: choosenCommunity!.id,
                                  community: choosenCommunity!)))
                      : Fluttertoast.showToast(
                          msg: "Choose a community first",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0),
                  child: const Text(
                    "Plan a jam",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          : const Text("You first need to join a community"),
    );
  }
}
