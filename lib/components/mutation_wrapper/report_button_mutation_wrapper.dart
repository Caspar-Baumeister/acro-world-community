import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ReportButtonMutationWrapper extends StatefulWidget {
  const ReportButtonMutationWrapper({
    super.key,
    required this.classId,
    required this.initialReported,
  });

  final String classId;
  final bool initialReported;

  @override
  State<ReportButtonMutationWrapper> createState() =>
      _ReportButtonMutationWrapperState();
}

class _ReportButtonMutationWrapperState
    extends State<ReportButtonMutationWrapper> {
  late bool isReported;

  @override
  void initState() {
    isReported = widget.initialReported;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: Mutation(
        options: MutationOptions(
          document: isReported ? Mutations.unFlagClass : Mutations.flagClass,
          onCompleted: (dynamic resultData) {
            setState(() {
              isReported = !isReported;
            });
            showSuccessToast(isReported
                ? "Flagged the event as not happening"
                : "Removed flag from event");
          },
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result == null || result.hasException) {
            // ignore: avoid_print
            print(result?.exception.toString());
            return Container();
          }
          if (result.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isReported ? Icons.flag : Icons.flag_outlined,
                color: isReported ? Colors.red : Colors.black,
              ),
            );
          }

          return IconButton(
              icon: Icon(
                isReported ? Icons.flag : Icons.flag_outlined,
                color: isReported ? Colors.red : Colors.black,
              ),
              onPressed: () => runMutation({
                    'class_id': widget.classId,
                    'user_id': Provider.of<UserProvider>(context, listen: false)
                        .activeUser!
                        .id!
                  }));
        },
      ),
    );
  }
}
