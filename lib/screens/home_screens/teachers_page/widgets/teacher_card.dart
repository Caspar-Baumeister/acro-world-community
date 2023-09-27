import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher_profile/single_teacher_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool loading = false;

  @override
  void initState() {
    isLikedState = widget.isLiked;
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
              builder: (context) =>
                  SingleTeacherQuery(teacherId: widget.teacher.id ?? "")),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.teacher.profilImgUrl ?? "",
            imageBuilder: (context, imageProvider) => Container(
              width: 64.0,
              height: 64.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
          title: Text(
            widget.teacher.name ?? "No name",
            style: H20W5,
          ),
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
                          color:
                              isLikedState ? BUTTON_FILL_COLOR : Colors.white,
                          border: Border.all(color: BUTTON_FILL_COLOR),
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
                                        : PRIMARY_COLOR,
                                  ))
                              : Text(
                                  isLikedState ? "Following" : "Follow",
                                  style: MEDIUM_BUTTON_TEXT.copyWith(
                                    color: !isLikedState
                                        ? BUTTON_FILL_COLOR
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
