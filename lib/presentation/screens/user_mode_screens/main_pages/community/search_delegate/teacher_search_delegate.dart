import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherSearchDelegate extends SearchDelegate<TeacherModel?> {
  TeacherSearchDelegate();

  @override
  String get searchFieldLabel => 'Search teachers...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to search for teachers...'),
      );
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authAsync = ref.watch(userRiverpodProvider);

        return authAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (user) {
            final userId = user?.id;
            QueryOptions options;

            if (userId == null) {
              options = QueryOptions(
                document: Queries.getTeacherForListWithoutUserID,
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {"search": "%$query%"},
              );
            } else {
              options = QueryOptions(
                document: Queries.getTeacherForList,
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {
                  "user_id": userId,
                  "search": "%$query%",
                },
              );
            }

            return Query(
              options: options,
              builder: (result, {refetch, fetchMore}) {
                if (result.hasException) {
                  return Center(
                    child: Text("Error: ${result.exception.toString()}"),
                  );
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = result.data;
                final list = data?["teachers"] as List<dynamic>? ?? [];
                final teachers =
                    list.map((item) => TeacherModel.fromJson(item)).toList();

                if (teachers.isEmpty) {
                  return const Center(
                    child: Text('No teachers found'),
                  );
                }

                return ListView.builder(
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return GestureDetector(
                      onTap: () => close(context, teacher),
                      child: TeacherCard(
                        teacher: teacher,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
