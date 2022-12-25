import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/single_teacher_page/widgets/class_section.dart';
import 'package:acroworld/screens/single_teacher_page/widgets/gallery_section.dart';
import 'package:acroworld/screens/single_teacher_page/widgets/info_section.dart';
import 'package:acroworld/utils/constants.dart';
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
                  child: Text("Classes", style: TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Flexible(
              child: TabBarView(
                children: [
                  ClassSection(
                    teacher: widget.teacher,
                  ),
                  GallerySection(pictureUrls: widget.teacher.pictureUrls),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

editProfile({String? dBKey}) {}
