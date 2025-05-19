import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherCard extends ConsumerStatefulWidget {
  const TeacherCard({
    super.key,
    required this.teacher,
    required this.isLiked,
  });

  final TeacherModel teacher;
  final bool isLiked;

  @override
  ConsumerState<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends ConsumerState<TeacherCard> {
  late bool isLikedState;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isLikedState = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    // Read current user once; .value may be null if not authenticated
    final currentUser = ref.watch(userRiverpodProvider).value;
    final userId = currentUser?.id;
    print('user slug: ${widget.teacher.slug}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: widget.teacher.slug != null
            ? () => context.pushNamed(
                  partnerSlugRoute,
                  pathParameters: {"slug": widget.teacher.slug!},
                )
            : null,
        child: ListTile(
          leading: CustomAvatarCachedNetworkImage(
            imageUrl: widget.teacher.profilImgUrl ?? "",
            radius: 64,
          ),
          title: Text(
            widget.teacher.name ?? "No name",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: Mutation(
            options: MutationOptions(
              document: isLikedState
                  ? Mutations.unlikeTeacher
                  : Mutations.likeTeacher,
            ),
            builder: (runMutation, result) {
              return GestureDetector(
                onTap: () {
                  if (userId == null) {
                    showErrorToast(
                      "You need to be logged in to follow teachers",
                    );
                    return;
                  }
                  setState(() => loading = true);

                  final variables = <String, dynamic>{
                    'teacher_id': widget.teacher.id,
                    if (isLikedState) 'user_id': userId,
                  };
                  runMutation(variables);

                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      isLikedState = !isLikedState;
                      loading = false;
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isLikedState ? CustomColors.primaryColor : Colors.white,
                    border: Border.all(color: CustomColors.primaryColor),
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
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: isLikedState
                                        ? Colors.white
                                        : CustomColors.primaryColor,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
