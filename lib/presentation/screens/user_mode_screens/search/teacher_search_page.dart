import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/appbar/base_appbar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherSearchPage extends StatefulWidget {
  const TeacherSearchPage({super.key});

  @override
  State<TeacherSearchPage> createState() => _TeacherSearchPageState();
}

class _TeacherSearchPageState extends State<TeacherSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 0),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search teachers...',
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.6),
                ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? const Center(
              child: Text('Start typing to search for teachers...'),
            )
          : Query(
              options: QueryOptions(
                document: Queries.getTeacherForListWithoutUserID,
                variables: {'search': '%$_query%'},
                fetchPolicy: FetchPolicy.networkOnly,
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (result.hasException) {
                  return Center(
                    child: Text('Error: ${result.exception.toString()}'),
                  );
                }

                final data = result.data;
                List<TeacherModel> teachers = [];

                if (data != null) {
                  final list = data["teachers"] as List<dynamic>?;
                  if (list != null) {
                    for (final item in list) {
                      teachers.add(TeacherModel.fromJson(item));
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      return TeacherCard(teacher: teacher);
                    },
                  ),
                );
              },
            ),
    );
  }
}
