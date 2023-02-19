import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher_profile/single_teacher_query.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ClassTeacherChips extends StatelessWidget {
  const ClassTeacherChips({Key? key, required this.teacher}) : super(key: key);

  final List<TeacherLinkModel> teacher;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CLASS_CARD_TEACHER_HEIGHT,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...teacher
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                          // Hier muss auf ein teacher query geschickte werden, der sich den teacher holt und dann auf teacher screen leitet
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleTeacherQuery(teacherId: t.id),
                            ),
                          ),
                          child: Chip(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.white,
                            label: Text(t.name),
                            avatar: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: t.profileImageUrl ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
          )),
    );
  }
}
