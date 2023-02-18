import 'package:acroworld/components/like_teacher_mutation_widget.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher_profile/screens/class_section.dart';
import 'package:acroworld/screens/teacher_profile/screens/gallery_screen.dart';
import 'package:acroworld/screens/teacher_profile/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';

class ProfileBaseScreen extends StatefulWidget {
  const ProfileBaseScreen(
      {Key? key, required this.teacher, required this.isLiked})
      : super(key: key);

  final TeacherModel teacher;
  final bool isLiked;
  @override
  _ProfileBaseScreenState createState() => _ProfileBaseScreenState();
}

class _ProfileBaseScreenState extends State<ProfileBaseScreen> {
  late bool isLikedState;
  late int teacherLikes;

  @override
  void initState() {
    super.initState();
    teacherLikes = widget.teacher.likes ?? 0;
    isLikedState = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 238, 238, 238),
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              widget.teacher.name ?? "Unknown",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: HeartMutationWidget(
                    isLiked: isLikedState,
                    teacherLikes: teacherLikes,
                    setIsLiked: (liked) => setState(() {
                          isLikedState = liked;
                        }),
                    setTeacherLikes: (likes) => setState(() {
                          teacherLikes = likes;
                        }),
                    teacherId: widget.teacher.id!),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ProfileHeaderWidget(
                      teacher: widget.teacher,
                      isLiked: widget.isLiked,
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ClassSection(teacher: widget.teacher),
                    Gallery(pictureUrls: widget.teacher.pictureUrls),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
