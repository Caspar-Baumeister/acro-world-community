import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final classReportsProvider =
    AsyncNotifierProvider<ClassReportsNotifier, Map<String, ReportState>>(
  ClassReportsNotifier.new,
);

class ReportState {
  final bool isReported;
  final bool isActive;

  const ReportState({
    this.isReported = false,
    this.isActive = false,
  });
}

class ClassReportsNotifier extends AsyncNotifier<Map<String, ReportState>> {
  @override
  Future<Map<String, ReportState>> build() async {
    final auth = ref.watch(authProvider);
    if (auth.value?.status != AuthStatus.authenticated) {
      return {};
    }
    return _fetchReports();
  }

  Future<Map<String, ReportState>> _fetchReports() async {
    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(
        QueryOptions(
          document: gql('''
            query {
              me {
                class_flags {
                  class_id
                  is_active
                }
              }
            }
          '''),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error fetching reports: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        throw result.exception!;
      }

      final reports = <String, ReportState>{};
      final flagsList = result.data?['me']?[0]?['class_flags'] ?? [];
      for (final flag in flagsList) {
        reports[flag['class_id']] = ReportState(
          isReported: true,
          isActive: flag['is_active'] ?? false,
        );
      }
      return reports;
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in _fetchReports: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> toggleReport(String classId) async {
    try {
      final currentUser = ref.read(userRiverpodProvider).value;
      if (currentUser == null) {
        CustomErrorHandler.captureException(
          'Attempted to toggle report without authenticated user: userId is null',
        );
        return;
      }

      // Get current state safely
      final currentState = state.value ?? {};
      final currentReport = currentState[classId] ?? const ReportState();
      final newReport = ReportState(
        isReported: !currentReport.isReported,
        isActive: currentReport.isActive,
      );

      // Optimistic update
      state = AsyncData({
        ...currentState,
        classId: newReport,
      });

      final client = GraphQLClientSingleton().client;
      final result = await client.mutate(
        MutationOptions(
          document: newReport.isReported
              ? Mutations.flagClass
              : Mutations.unFlagClass,
          variables: {
            'class_id': classId,
            'user_id': currentUser.id,
          },
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error toggling report: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        state = AsyncData(currentState);
        throw result.exception!;
      }

      // Show success message
      if (newReport.isReported) {
        showSuccessToast("Flagged the event");
      } else {
        showSuccessToast("Removed flag from event");
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in toggleReport: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }
}
