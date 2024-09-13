import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CommunityStep extends StatefulWidget {
  const CommunityStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  State<CommunityStep> createState() => _CommunityStepState();
}

class _CommunityStepState extends State<CommunityStep> {
  late TextEditingController teacherQueryController;
  String? _errorMessage;
  String query = '';

  @override
  void initState() {
    super.initState();

    teacherQueryController = TextEditingController();
    teacherQueryController.addListener(() {
      setState(() {
        query = teacherQueryController.text;
      });
    });
  }

  @override
  void dispose() {
    teacherQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.medium,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
              child: Text(
                  "Invite teachers to your event. The more teachers you invite, the more user will see your event.",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: AppPaddings.medium),
            // Input field with search suggestions
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                print("activeUser: ${userProvider.activeUser?.id}");
                for (var element
                    in eventCreationAndEditingProvider.pendingInviteTeachers) {
                  print("pendingInviteTeachers: ${element.userId}");
                }
                return InputFieldComponent(
                  controller: teacherQueryController,
                  labelText: 'Search for teachers',
                  isFootnoteError: false,
                  footnoteText: eventCreationAndEditingProvider
                          .pendingInviteTeachers
                          .any((TeacherModel teacher) =>
                              teacher.userId == userProvider.activeUser?.id)
                      ? null
                      : 'Tip: invite yourself to the event if you are teaching',
                );
              },
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Wrap(
                        spacing: 3,
                        children: eventCreationAndEditingProvider
                            .pendingInviteTeachers
                            .map((teacher) {
                          return TeacherOption(
                            teacher: teacher,
                            onDelete: () {
                              eventCreationAndEditingProvider
                                  .removePendingInviteTeacher(teacher.id!);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Center(
                        child:
                            StandardButton(onPressed: _onNext, text: 'Next')),
                    const SizedBox(height: AppPaddings.small),
                    _errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPaddings.medium,
                            ),
                            child: Text(
                              _errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: CustomColors.errorTextColor),
                            ),
                          )
                        : const SizedBox(height: AppPaddings.medium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.medium),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: query.isNotEmpty
                        ? TeacherSuggestionsQuery(
                            query: query,
                            alreadySelectedIds: eventCreationAndEditingProvider
                                .pendingInviteTeachers
                                .map((e) => e.id!)
                                .toList(),
                            onTeacherSelected: (TeacherModel teacher) {
                              eventCreationAndEditingProvider
                                  .addPendingInviteTeacher(teacher);
                              teacherQueryController.clear();
                            },
                            variables: (String query) {
                              return {
                                'limit': 10,
                                'offset': 0,
                                'where': {
                                  '_or': [
                                    {
                                      'name': {'_ilike': '$query%'}
                                    },
                                    {
                                      'user': {
                                        'email': {'_ilike': '$query%'}
                                      }
                                    },
                                  ],
                                },
                              };
                            },
                            identifier: 'teachers',
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
            // wrap the invited teachers
          ],
        ),
      ),
    );
  }

  void _onNext() {
    widget.onFinished();
  }
}

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
                  horizontal: AppPaddings.medium, vertical: AppPaddings.medium),
              margin: const EdgeInsets.symmetric(vertical: AppPaddings.small),
              decoration: BoxDecoration(
                color: CustomColors.backgroundColor,
                borderRadius: AppBorders.smallRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
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
                      padding: const EdgeInsets.only(right: AppPaddings.medium),
                      child: Row(
                        children: [
                          CustomAvatarCachedNetworkImage(
                            imageUrl: teacher.profilImgUrl,
                            radius: AppDimensions.avatarSizeMedium / 2,
                          ),
                          const SizedBox(width: AppPaddings.small),
                          Flexible(
                            child: Text(
                              teacher.name ?? "unknown",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
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

class TeacherOption extends StatelessWidget {
  final TeacherModel teacher;
  final VoidCallback? onDelete;

  const TeacherOption({
    super.key,
    required this.teacher,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(teacher.name ?? "unknown"),
      avatar: teacher.profilImgUrl != null
          ? CustomAvatarCachedNetworkImage(
              imageUrl: teacher.profilImgUrl,
              radius: AppDimensions.avatarSizeMedium,
            )
          : const CircleAvatar(child: Icon(Icons.person)),
      onDeleted: onDelete,
    );
  }
}
