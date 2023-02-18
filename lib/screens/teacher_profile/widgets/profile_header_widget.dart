import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/chatroom/fetch_community_chatroom.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget(
      {Key? key, required this.teacher, required this.isLiked})
      : super(key: key);

  final TeacherModel teacher;
  final bool isLiked;

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.teacher.profilePicUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.teacher.teacherLevels.isNotEmpty
                          ? Column(
                              children: [
                                const Text(
                                  "Level",
                                  style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DifficultyWidget(
                                        widget.teacher.teacherLevels),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      widget.teacher.locationName != "" &&
                              widget.teacher.teacherLevels.isNotEmpty
                          ? const SizedBox(
                              height: 30,
                            )
                          : Container(),
                      widget.teacher.locationName != ""
                          ? Column(
                              children: [
                                const Text(
                                  "Location",
                                  style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3),
                                      child: Text(
                                        widget.teacher.locationName ?? "",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.teacher.name ?? "No name",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
            widget.teacher.description != "" &&
                    widget.teacher.description != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: DescriptionTextWidget(
                      text: widget.teacher.description!,
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            widget.teacher.communityID != null
                ? actions(context, widget.teacher.communityID!, null)
                : Container(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget actions(BuildContext context, String communityId, String? webUrl) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      webUrl != null
          ? Flexible(
              child: StandartButton(
              text: "Website",
              onPressed: () {},
            ))
          : Container(),
      webUrl != null ? const SizedBox(width: 15) : Container(),
      Flexible(
          child: StandartButton(
        text: "Community",
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FetchCommunityChatroom(
                    communityId: communityId,
                  )),
        ),
        // () => Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => COmmun(
        //           teacher: widget.teacher, isLiked: isLikedState)),
        // ),,
        isFilled: true,
      )),
    ],
  );
}
