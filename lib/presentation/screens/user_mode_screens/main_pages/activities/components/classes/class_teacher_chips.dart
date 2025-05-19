import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassTeacherChips extends StatelessWidget {
  const ClassTeacherChips({super.key, required this.classTeacherList});

  final List<TeacherModel> classTeacherList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...classTeacherList.map((teacher) => teacher.id != null &&
                    teacher.name != null &&
                    teacher.profilImgUrl != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      // Hier muss auf ein teacher query geschickte werden, der sich den teacher holt und dann auf teacher screen leitet
                      onTap: () => teacher.slug != null
                          // ? Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           SingleTeacherQuery(teacherId: teacher.id!),
                          //     ),
                          //   )
                          ? context.pushNamed(
                              partnerSlugRoute,
                              pathParameters: {
                                "slug": teacher.slug!,
                              },
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
                            width: AppDimensions.avatarSizeMedium,
                            height: AppDimensions.avatarSizeMedium,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: AppDimensions.avatarSizeMedium,
                            height: AppDimensions.avatarSizeMedium,
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: AppDimensions.avatarSizeMedium,
                            height: AppDimensions.avatarSizeMedium,
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
                  )
                : Container())
          ],
        ));
  }
}
