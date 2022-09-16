import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/teacher_likes/change_like_on_teacher.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher/single_teacher_page.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher, required this.isLiked})
      : super(key: key);

  final TeacherModel teacher;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SingleTeacherPage(
                    teacher: teacher,
                    isEdit: false,
                  )),
        ),
        child: ListTile(
            leading: CircleAvatar(
              radius: 32,
              backgroundImage: teacher.profilePicUrl != null
                  ? NetworkImage(teacher.profilePicUrl!)
                  : const AssetImage("assets/muscleup_drawing.png")
                      as ImageProvider,
            ),
            title: Text(
              teacher.name,
              style: MAINTEXT,
            ),
            subtitle: Text(teacher.locationName, style: SECONDARYTEXT),
            trailing: Container(
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
              child: Mutation(
                options: MutationOptions(
                    document: isLiked
                        ? Mutations.unlikeTeacher
                        : Mutations.likeTeacher),
                builder: (MultiSourceResult<dynamic> Function(
                            Map<String, dynamic>,
                            {Object? optimisticResult})
                        runMutation,
                    QueryResult<dynamic>? result) {
                  if (result != null) {
                    if (result.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (result.data?['insert_teacher_likes'] != null) {
                      // success
                      // trigger eventbus that refetches which teacher i like
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      final EventBusProvider eventBusProvider =
                          Provider.of<EventBusProvider>(context, listen: false);
                      final EventBus eventBus = eventBusProvider.eventBus;

                      isLiked
                          ? runMutation({
                              'teacher_id': teacher.id,
                              'user_id': userProvider.activeUser!.id!
                            })
                          : runMutation({
                              'teacher_id': teacher.id,
                            });
                      eventBus.fire(ChangeLikeEvent());
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 42,
                          color: const Color.fromARGB(255, 252, 113, 103),
                        ),
                        Text(
                          teacher.likes.toString(),
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
