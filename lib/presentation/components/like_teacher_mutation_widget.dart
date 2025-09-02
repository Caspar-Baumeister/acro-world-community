import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HeartMutationWidget extends ConsumerWidget {
  const HeartMutationWidget({
    super.key,
    required this.isLiked,
    required this.teacherLikes,
    required this.setIsLiked,
    required this.setTeacherLikes,
    required this.teacherId,
    this.size = 42,
  });

  final bool isLiked;
  final int teacherLikes;
  final void Function(bool liked) setIsLiked;
  final void Function(int likes) setTeacherLikes;
  final String teacherId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current user
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const SizedBox(
        width: 40,
        height: 40,
        child: Center(child: ModernSkeleton(width: 20, height: 20)),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (user) {
        final userId = user?.id;
        return GestureDetector(
          onTap: () async {
            final client = GraphQLClientSingleton().client;
            // choose mutation document
            final doc =
                isLiked ? Mutations.unlikeTeacher : Mutations.likeTeacher;
            // build variables
            final vars = <String, dynamic>{
              'teacher_id': teacherId,
              if (!isLiked && userId != null) 'user_id': userId,
            };
            // run mutation
            await client.mutate(
              MutationOptions(
                document: doc,
                variables: vars,
              ),
            );
            // optimistic UI updates
            setTeacherLikes(teacherLikes + (isLiked ? -1 : 1));
            setIsLiked(!isLiked);
          },
          child: HeartWidget(
            isLiked: isLiked,
            likes: teacherLikes,
            size: size,
          ),
        );
      },
    );
  }
}

class HeartWidget extends StatelessWidget {
  const HeartWidget({
    super.key,
    required this.isLiked,
    required this.likes,
    required this.size,
  });

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
          color: Theme.of(context).colorScheme.surface,
        ),
        Icon(
          isLiked ? Icons.favorite_sharp : Icons.favorite_border_sharp,
          size: size,
          color: Theme.of(context).colorScheme.primary,
        ),
        Center(
          child: Text(
            likes.toString(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}
