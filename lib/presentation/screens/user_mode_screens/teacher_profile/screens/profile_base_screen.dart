import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/class_section.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/gallery_screen.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/profile_header_widget.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProfileBaseScreen extends ConsumerStatefulWidget {
  const ProfileBaseScreen({
    super.key,
    required this.teacher,
    required this.userId,
  });

  final TeacherModel teacher;
  final String userId;

  @override
  ConsumerState<ProfileBaseScreen> createState() => _ProfileBaseScreenState();
}

class _ProfileBaseScreenState extends ConsumerState<ProfileBaseScreen> {
  late bool isLikedState;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isLikedState = widget.teacher.likedByUser ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Scaffold(
            body: Center(child: Text('Error loading user')),
          ),
          data: (currentUser) {
            final myUserId = currentUser?.id;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                    ),
                  ),
                  child: AppBar(
                    // leading backbutton
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        if (!GoRouter.of(context).canPop()) {
                          // nothing to pop
                          context.go('/community');
                        } else {
                          // pop the current screen
                          GoRouter.of(context).pop();
                        }
                      },
                    ),
                    backgroundColor: Colors.white,
                    title: Text(
                      widget.teacher.name ?? "Unknown",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    elevation: 0,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, top: 5, bottom: 5),
                        child: Mutation(
                          options: MutationOptions(
                              document: isLikedState
                                  ? Mutations.unlikeTeacher
                                  : Mutations.likeTeacher),
                          builder: (runMutation, result) {
                            return GestureDetector(
                              onTap: () {
                                if (myUserId == null) {
                                  showErrorToast(
                                      "You need to be logged in to follow teachers");
                                  return;
                                }
                                setState(() => loading = true);

                                final vars = <String, dynamic>{
                                  'teacher_id': widget.teacher.id,
                                  if (isLikedState) 'user_id': myUserId,
                                };
                                runMutation(vars);
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
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
                                  border: Border.all(
                                      color: CustomColors.primaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 35,
                                width: 100,
                                alignment: Alignment.center,
                                child: loading
                                    ? SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: CircularProgressIndicator(
                                            color: isLikedState
                                                ? Colors.white
                                                : CustomColors.primaryColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        isLikedState ? "Followed" : "Follow",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: isLikedState
                                                  ? Colors.white
                                                  : CustomColors.primaryColor,
                                            ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (ctx, _) => [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        ProfileHeaderWidget(
                          teacher: widget.teacher,
                          isLiked: isLikedState,
                        ),
                      ]),
                    ),
                  ],
                  body: Column(
                    children: [
                      Material(
                        color: Colors.white,
                        child: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                          indicatorWeight: 1,
                          indicatorColor: Colors.black,
                          tabs: const [
                            Tab(icon: Icon(Icons.festival_outlined)),
                            Tab(icon: Icon(Icons.grid_on_sharp)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ClassSection(teacherId: widget.teacher.id!),
                            Gallery(images: widget.teacher.images),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
