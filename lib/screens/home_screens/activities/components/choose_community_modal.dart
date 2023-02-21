import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/create_jam/create_jam.dart';
import 'package:acroworld/screens/chatroom/widgets/time_bubble.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ChooseCommunityModal extends StatefulWidget {
  const ChooseCommunityModal({Key? key, required this.communities, this.day})
      : super(key: key);

  final List<Community> communities;
  final DateTime? day;

  @override
  State<ChooseCommunityModal> createState() => _ChooseCommunityModalState();
}

class _ChooseCommunityModalState extends State<ChooseCommunityModal> {
  late String? dropdownValue;
  late Community? choosenCommunity;

  @override
  void initState() {
    print(widget.day.toString());
    if (widget.communities.isNotEmpty) {
      choosenCommunity = widget.communities[0];
      dropdownValue = widget.communities[0].id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> communitiesDropdown = [];
    print("comminities with keys");
    for (var community in widget.communities) {
      print(community.id);

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
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(10),
      child: widget.communities.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Creating a new jam for ${readableTimeDateTime(widget.day!)}",
                    style: SUB_TITLE,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select a community",
                  textAlign: TextAlign.start,
                  style: STANDART_DESCRIPTION,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: DropdownButton(
                    iconEnabledColor: PRIMARY_COLOR,
                    value: dropdownValue,
                    items: communitiesDropdown,
                    style: STANDART_DESCRIPTION.copyWith(color: PRIMARY_COLOR),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        choosenCommunity = widget.communities
                            .firstWhere((element) => element.id == value);
                        dropdownValue = choosenCommunity!.id;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "The people inside the community will be notified. The jam must also be located in the area of the community base",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: WARNING_COLOR),
                ),
                const SizedBox(height: 20),
                Center(
                  child: StandartButton(
                    text: "Continue",
                    isFilled: true,
                    onPressed: choosenCommunity != null
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateJam(
                                          cid: choosenCommunity!.id,
                                          community: choosenCommunity!,
                                          initialDate: widget.day,
                                        )));
                          }
                        : () => Fluttertoast.showToast(
                            msg: "Choose a community first",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                // Center(
                //   child: OutlinedButton(
                //     style: OutlinedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(18),
                //       ),
                //     ),
                //     onPressed: choosenCommunity != null
                //         ? () {
                //             Navigator.pop(context);
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => CreateJam(
                //                           cid: choosenCommunity!.id,
                //                           community: choosenCommunity!,
                //                           initialDate: widget.day,
                //                         )));
                //           }
                //         : () => Fluttertoast.showToast(
                //             msg: "Choose a community first",
                //             toastLength: Toast.LENGTH_SHORT,
                //             gravity: ToastGravity.TOP,
                //             timeInSecForIosWeb: 2,
                //             backgroundColor: Colors.red,
                //             textColor: Colors.white,
                //             fontSize: 16.0),
                //     child: const Text(
                //       "Plan a jam",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w700,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          : const Text("You first need to join a community"),
    );
  }
}
