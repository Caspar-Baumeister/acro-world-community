import 'dart:ui';

import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/creator_settings_action_icon_button.dart';
import 'package:acroworld/provider/riverpod_provider/class_favorites_provider.dart';
import 'package:acroworld/provider/riverpod_provider/class_flags_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as Provider;

class BackDropActionRow extends ConsumerWidget {
  const BackDropActionRow({
    required this.isCollapsed,
    required this.classId,
    required this.shareEvents,
    required this.classObject,
    required this.classEventId,
    super.key,
    this.classEvent,
  });

  final bool isCollapsed;
  final String classId;
  final Function shareEvents;
  final ClassModel classObject;
  final String? classEventId;
  final ClassEvent? classEvent;

  Future<bool?> _showWarningDialog(BuildContext context) async {
    return showDialog<bool>(
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
                style: Theme.of(ctx).textTheme.displayMedium!.copyWith(
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
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text("Close",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  StandartButton(
                    text: "Report Event",
                    width: MediaQuery.of(ctx).size.width * 0.3,
                    isFilled: true,
                    onPressed: () => Navigator.of(ctx).pop(true),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleProvider = Provider.Provider.of<UserRoleProvider>(context);
    final favorites = ref.watch(classFavoritesProvider);
    final reports = ref.watch(classReportsProvider);
    final user = ref.watch(userRiverpodProvider);
    final isAuthenticated = user.value != null;

    double blurFactor = isCollapsed ? 0 : 4;
    List<Widget> actions = [
      IconButton(
        onPressed: () => shareEvents(),
        icon: const Icon(
          Icons.ios_share,
          color: Colors.black,
        ),
      ),
    ];

    if (userRoleProvider.isCreator) {
      try {
        actions.add(CreatorSettingsActionIconButton(
            classModel: classObject,
            classEventId: classEventId,
            classEvent: classEvent));
      } catch (e, s) {
        CustomErrorHandler.captureException(e, stackTrace: s);
      }
    } else {
      // Always show the icons, handle authentication in onPressed
      actions.add(
        favorites.when(
          data: (favMap) => IconButton(
            icon: Icon(
              favMap[classId] == true ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (!isAuthenticated) {
                showAuthRequiredDialog(
                  context,
                  subtitle:
                      'Log in or sign up to save events to your favorites and build your personal collection.',
                );
                return;
              }
              ref.read(classFavoritesProvider.notifier).toggleFavorite(classId);
            },
          ),
          loading: () => const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      );

      actions.add(
        reports.when(
          data: (reportMap) {
            final reportState = reportMap[classId] ?? const ReportState();
            return IconButton(
              icon: Icon(
                reportState.isReported ? Icons.flag : Icons.flag_outlined,
                color: reportState.isReported ? Colors.red : Colors.black,
              ),
              onPressed: () async {
                if (!isAuthenticated) {
                  showAuthRequiredDialog(
                    context,
                    subtitle:
                        'Log in or sign up to report events and help us maintain accurate information.',
                  );
                  return;
                }

                if (!reportState.isReported) {
                  final shouldReport = await _showWarningDialog(context);
                  if (shouldReport != true) return;
                }
                if (context.mounted) {
                  ref.read(classReportsProvider.notifier).toggleReport(classId);
                }
              },
            );
          },
          loading: () => const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      );
    }

    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurFactor, sigmaY: blurFactor),
          child: SizedBox(
            height: 65,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.small),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
