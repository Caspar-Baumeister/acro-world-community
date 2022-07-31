import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher}) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 400,
        child: Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              teacher.name,
              style: MAINTEXT,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                teacher.description,
                textAlign: TextAlign.center,
              ),
            ),
            PhotoGalery(teacher.pictureUrls),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("City: ${teacher.city}"),
                      const Text("Level: Advanced")
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Join"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        padding: const EdgeInsets.all(0),
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(maxHeight: 10),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.thumb_up,
                            color: PRIMARY_COLOR,
                          )),
                      Text(teacher.likes.toString())
                    ],
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class PhotoGalery extends StatelessWidget {
  const PhotoGalery(this.photos, {Key? key}) : super(key: key);
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.from(photos.map((e) => SizedBox(
              height: 140,
              width: 140,
              child: Image(
                image: NetworkImage(e),
                fit: BoxFit.cover,
              )))),
        ),
      ),
    );
  }
}
