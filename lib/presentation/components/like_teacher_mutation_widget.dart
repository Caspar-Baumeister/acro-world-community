import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class HeartMutationWidget extends StatelessWidget {
  const HeartMutationWidget(
      {super.key,
      required this.isLiked,
      required this.teacherLikes,
      required this.setIsLiked,
      required this.setTeacherLikes,
      required this.teacherId,
      this.size = 42});

  final bool isLiked;
  final int teacherLikes;
  final Function(bool liked) setIsLiked;
  final Function(int likes) setTeacherLikes;
  final String teacherId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: Mutation(
        options: MutationOptions(
            document:
                isLiked ? Mutations.unlikeTeacher : Mutations.likeTeacher),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          return GestureDetector(
              onTap: () {
                isLiked
                    ? runMutation({
                        'teacher_id': teacherId,
                        'user_id':
                            Provider.of<UserProvider>(context, listen: false)
                                .activeUser!
                                .id!
                      })
                    : runMutation({
                        'teacher_id': teacherId,
                      });
                Future.delayed(const Duration(milliseconds: 200), () {
                  setTeacherLikes(teacherLikes + (isLiked ? -1 : 1));
                });

                Future.delayed(const Duration(milliseconds: 200), () {
                  setIsLiked(!isLiked);
                });

                //eventBus.fire(ChangeLikeEvent());
              },
              child: HeartWidget(
                isLiked: isLiked,
                likes: teacherLikes,
                size: size,
              ));
        },
      ),
    );
  }
}

class HeartWidget extends StatelessWidget {
  const HeartWidget(
      {super.key,
      required this.isLiked,
      required this.likes,
      required this.size});

  final bool isLiked;
  final int likes;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Icon(
          Icons.favorite_sharp,
          size: size,
          color: Colors.white,
        ),
        Icon(
          isLiked ? Icons.favorite_sharp : Icons.favorite_border_sharp,
          size: size,
          color: CustomColors.primaryColor,
        ),
        Center(
          child: Text(
            likes.toString(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: isLiked ? Colors.white : CustomColors.primaryColor),
          ),
        )
      ],
    );
  }
}
