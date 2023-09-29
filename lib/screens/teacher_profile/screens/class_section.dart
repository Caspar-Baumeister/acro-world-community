import 'package:acroworld/components/class_widgets/class_template_card.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassSection extends StatelessWidget {
  const ClassSection({Key? key, required this.teacherId}) : super(key: key);

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getClassesByTeacherId,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {"teacher_id": teacherId}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading || result.data == null) {
            return const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: LoadingWidget(),
              ),
            );
          }

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          });

          List<ClassModel> classes = [];

          try {
            result.data!["classes"]
                .forEach((clas) => classes.add(ClassModel.fromJson(clas)));
          } catch (e) {
            print(e.toString());
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RefreshIndicator(
              onRefresh: () async => runRefetch(),
              child: classes.isEmpty
                  ? const Center(
                      child: Text("no classes"),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: classes.length,
                      itemBuilder: ((context, index) {
                        ClassModel indexClass = classes[index];
                        return ClassTemplateCard(indexClass: indexClass);
                      })),
            ),
          );
        });
  }
}
