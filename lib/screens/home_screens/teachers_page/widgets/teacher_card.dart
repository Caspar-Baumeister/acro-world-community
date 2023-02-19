import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher_profile/single_teacher_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool loading = false;

  @override
  void initState() {
    isLikedState = widget.isLiked;
    teacherLikes = widget.teacher.likes ?? 0;
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
                  SingleTeacherQuery(teacherId: widget.teacher.id!)),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.teacher.profilePicUrl!,
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
            style: MAINTEXT,
          ),
          subtitle: Text(widget.teacher.locationName ?? "no location provided",
              style: SECONDARYTEXT),
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
                      await followButtonClicked();
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
                                  style: SECONDARYTEXT.copyWith(
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

  // This controlls the joining and exiting from a community when following a teacher
  followButtonClicked() async {
    String? token = AuthProvider.token;
    final database = Database(token: token);
    String uid = Provider.of<UserProvider>(context, listen: false).getId();

    if (isLikedState) {
      await database.deleteUserCommunitiesOne(widget.teacher.communityID!);
      Fluttertoast.showToast(
          msg: "You left the community of ${widget.teacher.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      await database.insertUserCommunitiesOne(widget.teacher.communityID!, uid);
      Fluttertoast.showToast(
          msg: "You joint the community of ${widget.teacher.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
