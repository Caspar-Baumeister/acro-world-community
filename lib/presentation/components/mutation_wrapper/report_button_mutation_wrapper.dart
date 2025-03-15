import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
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
    required this.initiallyInActive,
  });

  final String classId;
  final bool initialReported;
  final bool initiallyInActive;

  @override
  State<ReportButtonMutationWrapper> createState() =>
      _ReportButtonMutationWrapperState();
}

class _ReportButtonMutationWrapperState
    extends State<ReportButtonMutationWrapper> {
  late bool isReported;
  late bool isActive;

  @override
  void initState() {
    isReported = widget.initialReported;
    isActive = !widget.initiallyInActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).activeUser!.id!;
    return Container(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: Mutation(
        options: MutationOptions(
          document: !isActive && isReported
              ? Mutations.activateFlag
              : isReported
                  ? Mutations.unFlagClass
                  : Mutations.flagClass,
          onCompleted: (dynamic resultData) {
            setState(() {
              isReported = !isReported;
            });
            showSuccessToast(
                isReported ? "Flagged the event" : "Removed flag from event");
          },
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result == null || result.hasException) {
            // ignore: avoid_print
            CustomErrorHandler.captureException(result?.exception.toString());
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

          return GestureDetector(
            onLongPressStart: (details) =>
                showInfoToast("Report the event as not happening or incorrect"),
            child: IconButton(
                icon: Icon(
                  isReported ? Icons.flag : Icons.flag_outlined,
                  color: isReported ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  if (!isReported) {
                    showWarningDialog(() => runMutation(
                        {'class_id': widget.classId, 'user_id': userId}));
                    return;
                  }

                  runMutation({'class_id': widget.classId, 'user_id': userId});

                  if (!isActive) {
                    isActive = true;
                  }
                }),
          );
        },
      ),
    );
  }

  void showWarningDialog(Function runMutation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flag_circle_outlined,
                    color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Flag Event",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure, that this event is not happening or incorrect?",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close",
                          style: TextStyle(color: Colors.grey)),
                    ),
                    StandardButton(
                      text: "Report Event",
                      width: MediaQuery.of(context).size.width * 0.3,
                      isFilled: true,
                      onPressed: () {
                        runMutation();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
