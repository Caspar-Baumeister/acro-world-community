import 'package:acroworld/components/like_teacher_mutation_widget.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher_profile/screens/profile_base_screen.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    teacherLikes = widget.teacher.likes ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ProfileBaseScreen(
                  teacher: widget.teacher, isLiked: isLikedState)),
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
          trailing: HeartMutationWidget(
            teacherId: widget.teacher.id!,
            isLiked: isLikedState,
            setIsLiked: (liked) => setState(() {
              isLikedState = liked;
            }),
            teacherLikes: teacherLikes,
            setTeacherLikes: (likes) => setState(() {
              teacherLikes = likes;
            }),
          ),
        ),
      ),
    );
  }
}
