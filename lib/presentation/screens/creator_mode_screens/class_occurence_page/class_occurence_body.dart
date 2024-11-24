import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/repositories/class_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_list_view.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class ClassOccurenceBody extends StatefulWidget {
  const ClassOccurenceBody({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  State<ClassOccurenceBody> createState() => _ClassOccurenceBodyState();
}

class _ClassOccurenceBodyState extends State<ClassOccurenceBody> {
  // switch value for upcoming and past events
  bool showPastEvents = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // switch between upcoming and past events
        Padding(
          padding: const EdgeInsets.only(
              left: AppPaddings.large,
              top: AppPaddings.small,
              right: AppPaddings.large),
          child: Row(
            children: [
              Switch(
                value: showPastEvents,
                onChanged: (value) {
                  setState(() {
                    showPastEvents = value;
                  });
                },
                activeTrackColor: CustomColors.successBgColorSec,
                activeColor: CustomColors.successBgColor,
                inactiveTrackColor: CustomColors.secondaryBackgroundColor,
                inactiveThumbColor: CustomColors.iconColor,
              ),
              SizedBox(width: AppPaddings.small),
              Text(
                "show also past events",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // list of occurences
        FutureBuilder<List<ClassEvent>>(
          future: ClassesRepository(apiService: GraphQLClientSingleton())
              .getUpcomingClassEventsById(
                  widget.classModel.id!, showPastEvents),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.hasError) {
              CustomErrorHandler.captureException(snapshot.error!,
                  stackTrace: snapshot.stackTrace);
              return ErrorWidget(snapshot.error!);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Expanded(
                child: const Center(
                  child: Text("No occurences found"),
                ),
              );
            } else {
              return ClassOccurenceListView(
                  classEvents: snapshot.data!,
                  refetch: () {
                    setState(() {});
                    print("setting state");
                  });
            }
          },
        ),
      ],
    );
  }
}
