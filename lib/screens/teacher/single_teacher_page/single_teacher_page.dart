import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home/chatroom/fetch_community_chatroom.dart';
import 'package:acroworld/screens/teacher/single_teacher_page/widgets/class_section.dart';
import 'package:acroworld/screens/teacher/widgets/edit_button.dart';
import 'package:acroworld/screens/teacher/single_teacher_page/widgets/gallery_section.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SingleTeacherPage extends StatefulWidget {
  const SingleTeacherPage(
      {Key? key, required this.teacher, required this.isEdit})
      : super(key: key);

  final TeacherModel teacher;
  final bool isEdit;

  @override
  State<SingleTeacherPage> createState() => _SingleTeacherPageState();
}

class _SingleTeacherPageState extends State<SingleTeacherPage> {
  late bool isEdit;

  @override
  void initState() {
    // TODO: implement initState
    isEdit = widget.isEdit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Text(widget.teacher.name),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: OutlinedButton(
          //       style: OutlinedButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(18),
          //         ),
          //       ),
          //       onPressed: () {
          //         setState(() {
          //           isEdit = !isEdit;
          //         });
          //       },
          //       child: Text(
          //         isEdit ? 'done' : "edit",
          //         style: const TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   )
          // ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoSection(teacher: widget.teacher, isEdit: isEdit),
            const Divider(color: PRIMARY_COLOR),
            const TabBar(
              padding: EdgeInsets.only(bottom: 6, top: 4),
              tabs: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text("Classes", style: TextStyle(color: Colors.black)),
                )
              ],
            ),
            const SizedBox(height: 6),
            Flexible(
              child: TabBarView(
                children: [
                  GallerySection(pictureUrls: widget.teacher.pictureUrls),
                  ClassSection(
                    teacher: widget.teacher,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
                    InfoRow(
                        value: teacher.teacherLevels.isNotEmpty
                            ? teacher.teacherLevels[0]
                            : "",
                        attributeKey: "Teaching level",
                        isEdit: isEdit,
                        dBKey: "level")
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

class InfoRow extends StatelessWidget {
  const InfoRow(
      {Key? key,
      required this.value,
      required this.attributeKey,
      required this.isEdit,
      this.dBKey})
      : super(key: key);
  final String value;
  final String attributeKey;
  final bool isEdit;
  final String? dBKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            attributeKey,
            maxLines: 2,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            maxLines: 2,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

editProfile({String? dBKey}) {}
