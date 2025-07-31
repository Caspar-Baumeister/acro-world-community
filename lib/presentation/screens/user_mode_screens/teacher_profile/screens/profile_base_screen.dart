import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/class_section.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/gallery_screen.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/profile_header_widget.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileBaseScreen extends ConsumerStatefulWidget {
  const ProfileBaseScreen({
    super.key,
    required this.teacher,
  });

  final TeacherModel teacher;

  @override
  ConsumerState<ProfileBaseScreen> createState() => _ProfileBaseScreenState();
}

class _ProfileBaseScreenState extends ConsumerState<ProfileBaseScreen> {
  bool loading = false;

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
            final teacherLikes = ref.watch(teacherLikesProvider);

            return teacherLikes.when(
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => Scaffold(
                body: Center(child: Text('Error loading teacher likes')),
              ),
              data: (likesMap) {
                final isLikedState = likesMap[widget.teacher.id] ?? false;

                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 238, 238, 238)),
                        ),
                      ),
                      child: AppBar(
                        // leading backbutton
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
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
                            child: GestureDetector(
                              onTap: () {
                                if (currentUser == null) {
                                  showAuthRequiredDialog(
                                    context,
                                    subtitle:
                                        'Log in or sign up to follow ${widget.teacher.name ?? "this partner"} and stay updated with their activities.',
                                  );
                                  return;
                                }
                                setState(() => loading = true);

                                ref
                                    .read(teacherLikesProvider.notifier)
                                    .toggleTeacherLike(widget.teacher.id!);

                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  setState(() {
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
          },
        );
  }
}
