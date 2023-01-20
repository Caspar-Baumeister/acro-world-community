import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/chatroom/fetch_community_chatroom.dart';
import 'package:acroworld/screens/single_teacher_page/widgets/info_row.dart';
import 'package:acroworld/screens/single_teacher_page/widgets/edit_button.dart';
import 'package:acroworld/components/spaced_column/spaced_column.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({Key? key, required this.teacher, required this.isEdit})
      : super(key: key);
  final TeacherModel teacher;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Image
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: teacher.profilePicUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 6),
                child: SpacedColumn(
                  space: 10,
                  children: [
                    InfoRow(
                      value: teacher.likes.toString(),
                      attributeKey: "Likes",
                      isEdit: false,
                    ),
                    InfoRow(
                        value: teacher.locationName,
                        attributeKey: "Location",
                        isEdit: isEdit,
                        dBKey: "location"),
                    teacher.teacherLevels.isNotEmpty
                        ? InfoRow(
                            value: teacher.teacherLevels.isNotEmpty
                                ? teacher.teacherLevels[0]
                                : "",
                            attributeKey: "Teaching level",
                            isEdit: isEdit,
                            dBKey: "level")
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width - (isEdit ? 100 : 50),
                  child: Text(
                    teacher.description,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                isEdit
                    ? const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: EditButton(
                          header: "Description",
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FetchCommunityChatroom(
                          communityId: teacher.communityID,
                        )),
              );
            },
            child: Text(
              "${teacher.name.split(" ")[0]}'s Community",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
