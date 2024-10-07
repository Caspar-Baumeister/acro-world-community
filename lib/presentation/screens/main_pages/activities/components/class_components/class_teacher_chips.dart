import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/teacher_profile/single_teacher_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ClassTeacherChips extends StatelessWidget {
  const ClassTeacherChips({super.key, required this.classTeacherList});

  final List<TeacherModel> classTeacherList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...classTeacherList.map((teacher) => Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      // Hier muss auf ein teacher query geschickte werden, der sich den teacher holt und dann auf teacher screen leitet
                      onTap: () => teacher.id != null
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleTeacherQuery(teacherId: teacher.id!),
                              ),
                            )
                          : null,
                      child: Chip(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                        label: Text(teacher.name ?? ""),
                        avatar: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: teacher.profilImgUrl ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 60.0,
                            height: 60.0,
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
            ],
          )),
    );
  }
}
