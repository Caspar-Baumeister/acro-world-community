import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_body.dart';
import 'package:acroworld/provider/riverpod_provider/teachers_pagination_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherQuery extends ConsumerStatefulWidget {
  const TeacherQuery({
    super.key,
    required this.search,
    required this.isFollowed,
  });

  final String search;
  final bool isFollowed;

  @override
  ConsumerState<TeacherQuery> createState() => _TeacherQueryState();
}

class _TeacherQueryState extends ConsumerState<TeacherQuery> {
  @override
  void initState() {
    super.initState();
    // Fetch teachers when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTeachers();
    });
  }

  @override
  void didUpdateWidget(TeacherQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch teachers when search or filter changes
    if (oldWidget.search != widget.search ||
        oldWidget.isFollowed != widget.isFollowed) {
      _fetchTeachers();
    }
  }

  void _fetchTeachers() {
    final authAsync = ref.read(userRiverpodProvider);
    authAsync.whenData((user) {
      ref.read(teachersPaginationProvider.notifier).fetchTeachers(
            searchQuery: widget.search,
            isFollowed: widget.isFollowed,
            userId: user?.id,
            isRefresh: true,
          );
    });
  }

  Widget _buildLoadingState(BuildContext context, {required String? userId}) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        try {
          _fetchTeachers();
        } catch (e, st) {
          CustomErrorHandler.captureException(
            e.toString(),
            stackTrace: st,
          );
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ...List.generate(15, (index) => const TeacherCardSkeleton()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(userRiverpodProvider);
    final teachersState = ref.watch(teachersPaginationProvider);

    return authAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModernSkeleton(width: 200, height: 20),
            SizedBox(height: 16),
            ModernSkeleton(width: 300, height: 100),
            SizedBox(height: 16),
            ModernSkeleton(width: 250, height: 80),
          ],
        ),
      ),
      error: (e, st) {
        CustomErrorHandler.captureException(e.toString(), stackTrace: st);
        return const Center(child: Text("Error loading user"));
      },
      data: (user) {
        if (teachersState.loading && teachersState.teachers.isEmpty) {
          return _buildLoadingState(context, userId: user?.id);
        }

        if (teachersState.error != null) {
          return Center(
            child: Text("Error: ${teachersState.error}"),
          );
        }

        return RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            try {
              _fetchTeachers();
            } catch (e, st) {
              CustomErrorHandler.captureException(
                e.toString(),
                stackTrace: st,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: CommunityBody(
              teachers: teachersState.teachers,
              canFetchMore: teachersState.canFetchMore,
              isLoadingMore: teachersState.loading,
              onLoadMore: () {
                ref.read(teachersPaginationProvider.notifier).fetchMore(
                      userId: user?.id,
                    );
              },
            ),
          ),
        );
      },
    );
  }
}
