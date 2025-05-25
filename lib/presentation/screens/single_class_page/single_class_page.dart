import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/custom_sliver_app_bar.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/back_drop_action_row.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/booking_query_wrapper.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
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

  void _shareEvent(ClassEvent? classEvent, ClassModel clas) {
    String deeplinkUrl = "https://acroworld.net/event/${clas.urlSlug}";
    if (classEvent?.id != null) {
      deeplinkUrl += "?event=${classEvent!.id!}";
    }
    String content = '''
Hi, I just found this event on AcroWorld:

${clas.name}
${formatInstructors(clas.classTeachers)}
${classEvent != null ? getDateStringMonthDay(DateTime.parse(classEvent.startDate!)) : ""}
At: ${clas.locationName}
''';
    if (clas.urlSlug != null) {
      content += "\n\nFind more info and book here: $deeplinkUrl";
    }
    Share.share(content);
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

        final billingTeacher = widget.clas.owner?.teacher?.stripeId != null
            ? widget.clas.owner
            : null;

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
                shareEvents: () => _shareEvent(
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
          bottomNavigationBar:
              widget.isCreator ? null : _buildBottomHoverButton(billingTeacher),
          body: CustomScrollView(
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
        );
      },
    );
  }

  BottomAppBar? _buildBottomHoverButton(ClassOwner? billingTeacher) {
    if (widget.classEvent != null &&
        widget.classEvent!.classModel!.bookingOptions.isNotEmpty &&
        billingTeacher != null) {
      if (kIsWeb) {
        return BottomAppBar(
          elevation: 0,
          child: CustomBottomHoverButton(
              content: const Text(
                "Booking only possible on mobile",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              onPressed: () => showErrorToast(
                    "Booking is currently only possible on mobile devices. Please use the AcroWorld app.",
                  )),
        );
      }

      return BottomAppBar(
        elevation: 0,
        child: BookingQueryHoverButton(
          classEvent: widget.classEvent!,
        ),
      );
    } else if (widget.classEvent != null) {
      return null;
    }
    return BottomAppBar(
      elevation: 0,
      child: CustomBottomHoverButton(
        content: const Text(
          "Calendar",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        onPressed: () => buildMortal(
          context,
          CalenderModal(
            classId: widget.clas.id!,
            isCreator: widget.isCreator,
          ),
        ),
      ),
    );
  }
}
