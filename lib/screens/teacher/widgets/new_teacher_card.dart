import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher/single_teacher_page.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class NewTeacherCard extends StatelessWidget {
  const NewTeacherCard({Key? key, required this.teacher}) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SingleTeacherPage(
                    teacher: teacher,
                  )),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(teacher.profilePicUrl),
          ),
          title: Text(
            teacher.name,
            style: MAINTEXT,
          ),
          subtitle: Text(teacher.city, style: SECONDARYTEXT),
          trailing: Stack(alignment: AlignmentDirectional.center, children: [
            const Icon(
              Icons.favorite,
              size: 42,
              color: Colors.red,
            ),
            Text(
              teacher.likes.toString(),
              style: SECONDARYTEXT.copyWith(fontSize: 12, color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}

class PhotoGallery extends StatelessWidget {
  const PhotoGallery(this.photos, {Key? key}) : super(key: key);
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.from(photos.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      height: 140,
                      width: 140,
                      image: NetworkImage(e),
                      fit: BoxFit.cover,
                    )),
              ))),
        ),
      ),
    );
  }
}
