import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/core/utils/helper_functions/find_billing_teacher.dart';
import 'package:acroworld/core/utils/helper_functions/formater.dart';
import 'package:acroworld/core/utils/helper_functions/modal_helpers.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/back_drop_action_row.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/booking_query_wrapper.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/presentation/shared_components/custom_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SingleClassPage extends StatefulWidget {
  const SingleClassPage({super.key, required this.clas, this.classEvent});

  final ClassModel clas;
  final ClassEvent? classEvent;

  @override
  State<SingleClassPage> createState() => _SingleClassPageState();
}

class _SingleClassPageState extends State<SingleClassPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _percentageCollapsed = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updatePercentage);
  }

  void _updatePercentage() {
    if (!_scrollController.hasClients) return;

    const double expandedHeight = appBarExpandedHeight - kToolbarHeight;
    final double currentHeight = appBarExpandedHeight -
        _scrollController.offset.clamp(0.0, expandedHeight);
    final double percentage = 1.0 - (currentHeight / expandedHeight);
    _percentageCollapsed.value = percentage;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updatePercentage);
    _scrollController.dispose();
    _percentageCollapsed.dispose();
    super.dispose();
  }

  void shareEvent(ClassEvent? classEvent, ClassModel clas) {
    String deeplinkUrl = "https://acroworld.net/event/${clas.urlSlug}";
    if (classEvent?.id != null) {
      deeplinkUrl += "/${classEvent!.id!}";
    }
    String content = '''
Hi, I just found this event on AcroWorld: 

${clas.name}
${formatInstructors(clas.classTeachers)}
${classEvent != null ? getDateStringMonthDay(DateTime.parse(classEvent.startDate!)) : null}
At: ${clas.locationName}
''';

    if (clas.urlSlug != null) {
      content +=
          "\n\nFind more information and book your spot here: $deeplinkUrl";
    }

    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    final ClassTeachers? billingTeacher =
        findFirstTeacherOrNull(widget.clas.classTeachers);

    List<Widget> actions = [];

    actions.add(
      ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          return BackDropActionRow(
              isCollapsed: percentage > appBarCollapsedThreshold,
              classId: widget.clas.id!,
              classEvent: widget.classEvent,
              initialFavorized: widget.clas.isInitiallyFavorized,
              initialReported: widget.clas.isInitiallyFlagged ?? false,
              shareEvents: () => shareEvent(widget.classEvent, widget.clas));
        },
      ),
    );

    return Scaffold(
      bottomNavigationBar: _buildBottomHoverButton(context, billingTeacher),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          CustomSliverAppBar(
              actions: actions,
              percentageCollapsed: _percentageCollapsed,
              headerText: widget.clas.name ?? "",
              imgUrl: widget.clas.imageUrl ?? "")
          // _buildSliverAppBar(context, _percentageCollapsed.value),
          ,
          SliverToBoxAdapter(
            child: SingleClassBody(
              classe: widget.clas,
              classEvent: widget.classEvent,
            ),
          ),
        ],
      ),
    );
  }

  BottomAppBar? _buildBottomHoverButton(
      BuildContext context, ClassTeachers? billingTeacher) {
    if (widget.classEvent != null &&
        widget.classEvent!.classModel?.classBookingOptions != null &&
        widget.classEvent!.classModel!.classBookingOptions!.isNotEmpty &&
        billingTeacher != null) {
      return BottomAppBar(
          elevation: 0,
          child: BookingQueryHoverButton(classEvent: widget.classEvent!));
    } else if (widget.classEvent != null) {
      return null;
    }
    return BottomAppBar(
        elevation: 0, child: Container(child: _buildCalendarButton(context)));
  }

  Widget _buildCalendarButton(BuildContext context) {
    return CustomBottomHoverButton(
      content: const Text(
        "Calendar",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      onPressed: () =>
          buildMortal(context, CalenderModal(classId: widget.clas.id!)),
    );
  }
}
