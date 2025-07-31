import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/presentation/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherSuggestionsQuery extends StatelessWidget {
  const TeacherSuggestionsQuery(
      {super.key,
      required this.query,
      required this.onTeacherSelected,
      required this.variables,
      required this.identifier,
      required this.alreadySelectedIds});

  final String query;
  final Function(TeacherModel teacher) onTeacherSelected;
  final Function(String query) variables;
  final String identifier;
  final List<String> alreadySelectedIds;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: Queries.getTeachersPageableQuery,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: variables(query)),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: const LoadingIndicator());
        }
        if (result.hasException) {
          return ErrorWidget(result.exception.toString());
        }
        if (result.data != null) {
          Map<String, dynamic> data = result.data!;
          if (data.isNotEmpty) {
            List<TeacherModel> teachers = [];
            try {
              teachers = data[identifier]
                  .map<TeacherModel>(
                      (teacher) => TeacherModel.fromJson(teacher))
                  .toList();
              teachers.removeWhere(
                  (teacher) => alreadySelectedIds.contains(teacher.id));
            } catch (e) {
              CustomErrorHandler.captureException(e);
              return ErrorWidget("Something unexpected went wrong");
            }

            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMedium, vertical: AppDimensions.spacingMedium),
              margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teachers.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const CustomDivider(),
                itemBuilder: (BuildContext context, int index) {
                  TeacherModel teacher = teachers[index];
                  return GestureDetector(
                    onTap: () {
                      onTeacherSelected(teacher);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppDimensions.spacingMedium),
                      child: Row(
                        children: [
                          CustomAvatarCachedNetworkImage(
                            imageUrl: teacher.profilImgUrl,
                            radius: AppDimensions.avatarSizeMedium / 2,
                          ),
                          const SizedBox(width: AppDimensions.spacingSmall),
                          Expanded(
                            child: Text(
                              teacher.name ?? "unknown",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingSmall),
                          Text(
                            "Follower: ${teacher.likes}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return ErrorWidget(
                "Something unexpected went wrong, restart or update your app");
          }
        }
        return Container();
      },
    );
  }
}
