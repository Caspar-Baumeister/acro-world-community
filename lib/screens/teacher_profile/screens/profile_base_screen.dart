import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher_profile/screens/class_section.dart';
import 'package:acroworld/screens/teacher_profile/screens/event_section.dart';
import 'package:acroworld/screens/teacher_profile/screens/gallery_screen.dart';
import 'package:acroworld/screens/teacher_profile/widgets/profile_header_widget.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProfileBaseScreen extends StatefulWidget {
  const ProfileBaseScreen(
      {Key? key, required this.teacher, required this.userId})
      : super(key: key);

  final TeacherModel teacher;
  final String userId;
  @override
  ProfileBaseScreenState createState() => ProfileBaseScreenState();
}

class ProfileBaseScreenState extends State<ProfileBaseScreen> {
  late bool isLikedState;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isLikedState =
        isTeacherFollowedByUser(widget.teacher.userLikes, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
                padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
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
                                color: isLikedState
                                    ? BUTTON_FILL_COLOR
                                    : Colors.white,
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
                                        style: H12W4.copyWith(
                                          color: !isLikedState
                                              ? BUTTON_FILL_COLOR
                                              : Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              )));
                    }),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ProfileHeaderWidget(
                      teacher: widget.teacher,
                      isLiked: isLikedState,
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
                        Icons.festival_outlined,
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
                    ClassSection(teacherId: widget.teacher.id!),
                    EventSection(teacherId: widget.teacher.id!),
                    Gallery(images: widget.teacher.images),
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
