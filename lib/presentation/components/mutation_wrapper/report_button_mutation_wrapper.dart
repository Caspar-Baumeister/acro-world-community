import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ReportButtonMutationWrapper extends ConsumerStatefulWidget {
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
  ConsumerState<ReportButtonMutationWrapper> createState() =>
      _ReportButtonMutationWrapperState();
}

class _ReportButtonMutationWrapperState
    extends ConsumerState<ReportButtonMutationWrapper> {
  late bool _isReported;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isReported = widget.initialReported;
    _isActive = !widget.initiallyInActive;
  }

  Future<void> _runFlagMutation(document, Map<String, dynamic> vars,
      {required String successMessage, required String undoMessage}) async {
    final client = GraphQLClientSingleton().client;
    try {
      final res = await client.mutate(MutationOptions(
        document: document,
        variables: vars,
      ));
      if (res.hasException) {
        throw res.exception!;
      }
      setState(() {
        _isReported = !_isReported;
        if (!_isActive && _isReported) {
          _isActive = true;
        }
      });
      showSuccessToast(_isReported ? successMessage : undoMessage);
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      showErrorToast("Action failed. Please try again.");
    }
  }

  void _onIconPressed(String userId) {
    if (!_isReported) {
      _showWarningDialog(userId);
      return;
    }
    final document = (!_isActive && _isReported)
        ? Mutations.activateFlag
        : Mutations.unFlagClass;
    final vars = {'class_id': widget.classId, 'user_id': userId};
    _runFlagMutation(
      document,
      vars,
      successMessage: "Flagged the event",
      undoMessage: "Removed flag from event",
    );
  }

  void _showWarningDialog(String userId) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                "Are you sure this event is not happening or incorrect?",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Close",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  StandartButton(
                    text: "Report Event",
                    width: MediaQuery.of(context).size.width * 0.3,
                    isFilled: true,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _runFlagMutation(
                        Mutations.flagClass,
                        {'class_id': widget.classId, 'user_id': userId},
                        successMessage: "Flagged the event",
                        undoMessage: "Removed flag from event",
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (user) {
            final userId = user?.id;
            if (userId == null) return const SizedBox.shrink();

            return SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: Icon(
                  _isReported ? Icons.flag : Icons.flag_outlined,
                  color: _isReported ? Colors.red : Colors.black,
                ),
                onPressed: () => _onIconPressed(userId),
                tooltip: _isReported
                    ? "Remove flag"
                    : "Flag event as incorrect or not happening",
              ),
            );
          },
        );
  }
}
