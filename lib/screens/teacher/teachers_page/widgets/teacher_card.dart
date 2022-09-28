import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher/single_teacher_page/single_teacher_page.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherCard extends StatefulWidget {
  const TeacherCard({Key? key, required this.teacher, required this.isLiked})
      : super(key: key);

  final TeacherModel teacher;
  final bool isLiked;

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  late bool isLikedState;
  late int teacherLikes;

  @override
  void initState() {
    isLikedState = widget.isLiked;
    teacherLikes = widget.teacher.likes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SingleTeacherPage(
                    teacher: widget.teacher,
                    isEdit: false,
                  )),
        ),
        child: ListTile(
            leading: CircleAvatar(
              radius: 32,
              backgroundImage: widget.teacher.profilePicUrl != null
                  ? NetworkImage(widget.teacher.profilePicUrl!)
                  : const AssetImage("assets/muscleup_drawing.png")
                      as ImageProvider,
            ),
            title: Text(
              widget.teacher.name,
              style: MAINTEXT,
            ),
            subtitle: Text(widget.teacher.locationName, style: SECONDARYTEXT),
            trailing: Container(
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
              child: Mutation(
                options: MutationOptions(
                    document: isLikedState
                        ? Mutations.unlikeTeacher
                        : Mutations.likeTeacher),
                builder: (MultiSourceResult<dynamic> Function(
                            Map<String, dynamic>,
                            {Object? optimisticResult})
                        runMutation,
                    QueryResult<dynamic>? result) {
                  if (result != null) {
                    if (result.isLoading) {
                      return const Icon(
                        Icons.favorite,
                        size: 42,
                        color: Color.fromARGB(255, 252, 113, 103),
                      );
                    }
                    if (result.data?['insert_teacher_likes'] != null) {
                      // success
                      // trigger eventbus that refetches which teacher i like
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      // final EventBusProvider eventBusProvider =
                      //     Provider.of<EventBusProvider>(context, listen: false);
                      // final EventBus eventBus = eventBusProvider.eventBus;

                      isLikedState
                          ? runMutation({
                              'teacher_id': widget.teacher.id,
                              'user_id': userProvider.activeUser!.id!
                            })
                          : runMutation({
                              'teacher_id': widget.teacher.id,
                            });
                      isLikedState
                          ? Future.delayed(const Duration(milliseconds: 200),
                              () {
                              setState(() {
                                teacherLikes -= 1;
                              });
                            })
                          : Future.delayed(const Duration(milliseconds: 200),
                              () {
                              setState(() {
                                teacherLikes += 1;
                              });
                            });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          isLikedState = !isLikedState;
                        });
                      });

                      //eventBus.fire(ChangeLikeEvent());
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Icon(
                          isLikedState ? Icons.favorite : Icons.favorite_border,
                          size: 42,
                          color: const Color.fromARGB(255, 252, 113, 103),
                        ),
                        Text(
                          teacherLikes.toString(),
                          style: SECONDARYTEXT.copyWith(
                              fontSize: 12, color: Colors.black),
                        )
                      ],
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
