import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget(
      {super.key, required this.teacher, required this.isLiked});

  final TeacherModel teacher;
  final bool isLiked;

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                imageUrl: widget.teacher.profilImgUrl ?? "",
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
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        widget.teacher.name ?? "No name",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.4,
                        ),
                      ),
                      widget.teacher.likes != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "${widget.teacher.likes} followers",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          widget.teacher.description != "" && widget.teacher.description != null
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
        ],
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
              child: StandardButton(
              text: "Website",
              onPressed: () {},
            ))
          : Container(),
      webUrl != null ? const SizedBox(width: 15) : Container(),
      // Flexible(
      //     child: StandartButton(
      //   text: "Community",
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => FetchCommunityChatroom(
      //               communityId: communityId,
      //             )),
      //   ),
      //   // () => Navigator.of(context).push(
      //   //   MaterialPageRoute(
      //   //       builder: (context) => COmmun(
      //   //           teacher: widget.teacher, isLiked: isLikedState)),
      //   // ),,
      //   isFilled: true,
      // )),
    ],
  );
}
