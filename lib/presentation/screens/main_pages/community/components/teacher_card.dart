import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/teacher_profile/single_teacher_query.dart';
import 'package:acroworld/presentation/shared_components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/state/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherCard extends StatefulWidget {
  const TeacherCard({super.key, required this.teacher, required this.isLiked});

  final TeacherModel teacher;
  final bool isLiked;

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  late bool isLikedState;
  bool loading = false;

  @override
  void initState() {
    isLikedState = widget.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  SingleTeacherQuery(teacherId: widget.teacher.id ?? "")),
        ),
        child: ListTile(
          leading: CustomAvatarCachedNetworkImage(
            imageUrl: widget.teacher.profilImgUrl ?? "",
            radius: 64,
          ),
          title: Text(widget.teacher.name ?? "No name",
              style: Theme.of(context).textTheme.titleLarge),
          // subtitle: Text(widget.teacher.locationName ?? "no location provided",
          //     style: SMALL_TEXT_STYLE),
          trailing: Mutation(
              options: MutationOptions(
                  document: isLikedState
                      ? Mutations.unlikeTeacher
                      : Mutations.likeTeacher),
              builder: (MultiSourceResult<dynamic> Function(
                          Map<String, dynamic>,
                          {Object? optimisticResult})
                      runMutation,
                  QueryResult<dynamic>? result) {
                return GestureDetector(
                    onTap: () async {
                      UserProvider userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      if (userProvider.activeUser?.id == null) {
                        showErrorToast(
                          "You need to be logged in to be able to follow teachers",
                        );

                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      isLikedState
                          ? runMutation({
                              'teacher_id': widget.teacher.id,
                              'user_id': userProvider.activeUser!.id!
                            })
                          : runMutation({
                              'teacher_id': widget.teacher.id,
                            });

                      Future.delayed(const Duration(seconds: 0), () {
                        setState(() {
                          isLikedState = !isLikedState;
                          loading = false;
                        });
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: isLikedState
                              ? CustomColors.primaryColor
                              : Colors.white,
                          border: Border.all(color: CustomColors.primaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 35,
                        width: 100,
                        child: Center(
                          child: loading
                              ? Container(
                                  height: 25,
                                  width: 25,
                                  padding: const EdgeInsets.all(5),
                                  child: CircularProgressIndicator(
                                    color: isLikedState == true
                                        ? Colors.white
                                        : CustomColors.primaryColor,
                                  ))
                              : Text(
                                  isLikedState ? "Followed" : "Follow",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: !isLikedState
                                            ? CustomColors.primaryColor
                                            : Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                        )));
              }),
        ),
      ),
    );
  }
}
