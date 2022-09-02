import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class SingleTeacherPage extends StatelessWidget {
  const SingleTeacherPage({Key? key, required this.teacher}) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Text(teacher.name),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoSection(
              teacher: teacher,
            ),
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
                  GallerySection(pictureUrls: teacher.pictureUrls),
                  const Center(
                    child:
                        Text("The classes of Caspar will be available soon!"),
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
  const InfoSection({Key? key, required this.teacher}) : super(key: key);
  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: NetworkImage(teacher.profilePicUrl),
              ),
            ),
            InfoList(teacher: teacher)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
          child: Text(
            teacher.description,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class GallerySection extends StatelessWidget {
  const GallerySection({Key? key, required this.pictureUrls}) : super(key: key);
  final List<String> pictureUrls;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
      ),
      itemCount: pictureUrls.length,
      itemBuilder: (context, index) {
        return Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(pictureUrls[index]),
          ),
        ));
        // Item rendering
      },
    );
  }
}

class InfoList extends StatelessWidget {
  const InfoList({Key? key, required this.teacher}) : super(key: key);
  final TeacherModel teacher;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoRow(value: teacher.likes.toString(), attributeKey: "Likes"),
        InfoRow(value: teacher.city, attributeKey: "Location"),
        InfoRow(value: teacher.level, attributeKey: "Teaching level")
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({Key? key, required this.value, required this.attributeKey})
      : super(key: key);
  final String value;
  final String attributeKey;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(maxWidth: width / 2 - 44),
            child: Text(
              attributeKey,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            constraints: BoxConstraints(maxWidth: width / 2),
            child: Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
