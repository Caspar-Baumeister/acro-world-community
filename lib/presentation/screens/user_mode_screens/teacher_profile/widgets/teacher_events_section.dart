import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/cards/modern_class_card.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherEventsSection extends StatelessWidget {
  const TeacherEventsSection({
    super.key,
    required this.teacherId,
  });

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Query(
      options: QueryOptions(
        document: Queries.getClassesByTeacherId,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"teacher_id": teacherId},
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {

        if (result.hasException) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Error loading events: ${result.exception.toString()}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          );
        }

        if (result.isLoading || result.data == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 200,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: ModernSkeleton(width: 150, height: 20),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        List<ClassModel> classes = [];

        try {
          print(
              '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection parsing classes:');
          print('  classes data: ${result.data!["classes"]}');
          print('  classes count: ${result.data!["classes"]?.length ?? 0}');

          result.data!["classes"]
              .forEach((clas) => classes.add(ClassModel.fromJson(clas)));

          print(
              '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection parsed classes:');
          print('  parsed classes count: ${classes.length}');
          for (int i = 0; i < classes.length && i < 3; i++) {
            print(
                '  class[$i]: id=${classes[i].id}, name=${classes[i].name}, urlSlug=${classes[i].urlSlug}');
          }
        } catch (e) {
          print(
              '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection Parse Error: $e');
          CustomErrorHandler.captureException(e.toString(),
              stackTrace: StackTrace.current);
        }

        classes = classes.where((element) => element.urlSlug != null).toList();

        print(
            '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection final filtered classes:');
        print('  filtered classes count: ${classes.length}');

        if (classes.isEmpty) {
          print(
              '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection showing empty state');
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No events available",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "This teacher hasn't created any events yet.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        print(
            '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection rendering events list with ${classes.length} classes');
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and view all button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Events',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full events page for this teacher
                      context.pushNamed(
                        partnerSlugRoute,
                        pathParameters: {"slug": teacherId},
                        queryParameters: {"tab": "events"},
                      );
                    },
                    child: Text(
                      'View All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Horizontal scrollable events
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    print(
                        '🔍 TEACHER EVENTS DEBUG - TeacherEventsSection rendering class card $index: ${classes[index].name}');
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ModernClassCard(
                        classModel: classes[index],
                        width: 200,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
