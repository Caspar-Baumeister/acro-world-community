import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/custom_sliver_app_bar.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/back_drop_action_row.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/single_class_bottom_hover_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class SingleClassPage extends ConsumerStatefulWidget {
  const SingleClassPage({
    super.key,
    required this.clas,
    this.classEvent,
    this.isCreator = false,
  });

  final ClassModel clas;
  final ClassEvent? classEvent;
  final bool isCreator;

  @override
  ConsumerState<SingleClassPage> createState() => _SingleClassPageState();
}

class _SingleClassPageState extends ConsumerState<SingleClassPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _percentageCollapsed = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updatePercentage);
  }

  void _updatePercentage() {
    if (!_scrollController.hasClients) return;
    const expandedHeight = appBarExpandedHeight - kToolbarHeight;
    final currentHeight = appBarExpandedHeight -
        _scrollController.offset.clamp(0.0, expandedHeight);
    final percentage = 1.0 - (currentHeight / expandedHeight);
    _percentageCollapsed.value = percentage;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updatePercentage);
    _scrollController.dispose();
    _percentageCollapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const LoadingPage(),
      error: (_, __) => const ErrorPage(
        error: "Error loading user. Please log in again.",
      ),
      data: (user) {
        final userId = user?.id;
        if (userId == null) {
          return const ErrorPage(
            error: "You need to be logged in to view this page.",
          );
        }

        List<Widget> actions = [
          ValueListenableBuilder<double>(
            valueListenable: _percentageCollapsed,
            builder: (context, percentage, _) {
              return BackDropActionRow(
                isCollapsed: percentage > appBarCollapsedThreshold,
                classId: widget.clas.id!,
                classObject: widget.clas,
                initialFavorized: widget.clas.isInitiallyFavorized,
                initialReported: widget.clas.flaggedByUser(userId),
                initialInActive: widget.clas.inActiveFlaggsByUser(userId),
                shareEvents: () => shareEvent(
                  widget.classEvent,
                  widget.clas,
                ),
                isCreator: widget.isCreator,
                classEvent: widget.classEvent,
                classEventId: widget.classEvent?.id,
              );
            },
          ),
        ];

        return Scaffold(
          bottomNavigationBar: SingleClassBottomHoverButton(
            clas: widget.clas,
            classEvent: widget.classEvent,
            isCreator: widget.isCreator,
          ),
          body: Padding(
            padding: kIsWeb
                ? EdgeInsets.symmetric(horizontal: 100.0)
                : const EdgeInsets.all(0.0),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomSliverAppBar(
                  actions: actions,
                  percentageCollapsed: _percentageCollapsed,
                  headerText: widget.clas.name ?? "",
                  imgUrl: widget.clas.imageUrl ?? "",
                  tag: widget.clas.imageUrl,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: AppPaddings.large,
                          )
                        : EdgeInsets.all(0),
                    child: SingleClassBody(
                      classe: widget.clas,
                      classEvent: widget.classEvent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Helper function to share a class event via a dynamic deep link.
void shareEvent(ClassEvent? classEvent, ClassModel clas) {
  // Build base deep link URL
  String deeplinkUrl = "https://acroworld.net/event/${clas.urlSlug}";
  if (classEvent?.id != null) {
    deeplinkUrl += "?event=${classEvent!.id!}";
  }

  // Compose share content
  String content = '''
Hi, I just found this event on AcroWorld:

${clas.name}
${formatInstructors(clas.classTeachers)}
${classEvent != null ? getDateStringMonthDay(DateTime.parse(classEvent.startDate!)) : ''}
At: ${clas.locationName}
''';

  if (clas.urlSlug != null) {
    content += "\n\nFind more info and book here: $deeplinkUrl";
  }

  // Trigger the native share dialog
  Share.share(content);
}
