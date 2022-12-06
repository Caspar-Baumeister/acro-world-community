import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home_folder/chatroom/chatroom.dart';
import 'package:acroworld/screens/home_folder/chatroom/widgets/time_bubble.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  Widget build(BuildContext context) {
    bool isNew = false;
    DateTime? createdAt;
    DateTime? lastVisitedAt;
    DateTime? nextJamAt;
    if (community.nextJamAt != null) {
      nextJamAt = DateTime.parse(community.nextJamAt!);
    }
    if (community.lastMessage?.createdAt != null &&
        community.lastVisitedAt != null) {
      createdAt = DateTime.parse(community.lastMessage!.createdAt!);
      lastVisitedAt = DateTime.parse(community.lastVisitedAt!);
      if (createdAt.isAfter(lastVisitedAt)) {
        isNew = true;
      }
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Chatroom(
                  cId: community.id,
                  community: community,
                  name: community.name,
                )),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage("assets/logo/play_store_512.png"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      community.lastMessage?.createdAt != null
                          ? Container(
                              constraints: const BoxConstraints(maxWidth: 65),
                              child: Text(
                                readableTimeString(
                                    community.lastMessage!.createdAt!),
                                style: TextStyle(
                                    fontSize: isNew ? 13 : 12,
                                    overflow: TextOverflow.fade,
                                    color: isNew ? PRIMARY_COLOR : Colors.black,
                                    fontWeight: isNew
                                        ? FontWeight.bold
                                        : FontWeight.w300),
                                maxLines: 1,
                                textAlign: TextAlign.right,
                              ))
                          : Container()
                    ],
                  ),
                  community.lastMessage?.fromUser?.name != null &&
                          community.lastMessage?.content != null
                      ? RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(overflow: TextOverflow.ellipsis),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "${community.lastMessage!.fromUser!.name}: ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: community.lastMessage!.content,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
      
      
      
      // ListTile(
      //   leading: const CircleAvatar(
      //     radius: 32,
      //     backgroundImage: AssetImage("assets/logo/play_store_512.png"),
      //   ),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         community.name,
      //         style: const TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       community.lastMessage?.createdAt != null
      //           ? Container(
      //               constraints: const BoxConstraints(maxWidth: 60),
      //               child: Text(
      //                 readableTimeString(community.lastMessage!.createdAt!),
      //                 style: TextStyle(
      //                     fontSize: isNew ? 13 : 12,
      //                     overflow: TextOverflow.fade,
      //                     color: isNew ? PRIMARY_COLOR : Colors.black,
      //                     fontWeight:
      //                         isNew ? FontWeight.bold : FontWeight.w300),
      //                 maxLines: 1,
      //                 textAlign: TextAlign.right,
      //               ))
      //           : Container()
      //     ],
      //   ),
      //   subtitle:
      //       // Column(
      //       //   children: [
      //       Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Flexible(
      //         child: Container(
      //           child: community.lastMessage?.fromUser?.name != null &&
      //                   community.lastMessage?.content != null
      //               ? RichText(
      //                   overflow: TextOverflow.ellipsis,
      //                   text: TextSpan(
      //                     style: DefaultTextStyle.of(context)
      //                         .style
      //                         .copyWith(overflow: TextOverflow.ellipsis),
      //                     children: <TextSpan>[
      //                       TextSpan(
      //                           text:
      //                               "${community.lastMessage!.fromUser!.name}: ",
      //                           style: const TextStyle(
      //                               fontWeight: FontWeight.bold)),
      //                       TextSpan(
      //                           text: community.lastMessage!.content,
      //                           style: const TextStyle(
      //                               overflow: TextOverflow.ellipsis)),
      //                     ],
      //                   ),
      //                 )
      //               : null,
      //         ),
      //       ),
            // count != null && count > 0
            //     ? Container(
            //         height: 28,
            //         padding: const EdgeInsets.all(8),
            //         decoration: const BoxDecoration(
            //             color: SECONDARY_COLOR,
            //             borderRadius:
            //                 BorderRadius.all(Radius.circular(20))),
            //         child: Text(count.toString()))
            //     : Container()
        //   ],
        // ),
        // nextJamAt != null
        //     ? Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text(
        //             "upcoming event ${DateFormat.MMMMEEEEd().format(nextJamAt.toLocal())}"))
        //     : Container()
        //   ],
        // ),
    //   ),
    // );
  // }
// }
