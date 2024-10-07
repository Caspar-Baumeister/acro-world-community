import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/shared_components/buttons/standart_button.dart';
import 'package:acroworld/presentation/shared_components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/presentation/shared_components/show_more_text.dart';
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
              CustomAvatarCachedNetworkImage(
                imageUrl: widget.teacher.profilImgUrl ?? "",
                radius: 150,
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.medium,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.teacher.name ?? "No name",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        widget.teacher.likes != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "${widget.teacher.likes} follower",
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
    ],
  );
}
