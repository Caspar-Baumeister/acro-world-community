import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/components/custom_sliver_app_bar.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/single_event/single_event_body.dart';
import 'package:acroworld/screens/single_event/widgets/back_drop_action_row_event.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class SingleEventPage extends StatefulWidget {
  const SingleEventPage({super.key, required this.event});

  final EventModel event;

  @override
  State<SingleEventPage> createState() => _SingleEventPageState();
}

class _SingleEventPageState extends State<SingleEventPage> {
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

  void shareEvent(EventModel event) {
    final String content = '''
${event.name}

${formatInstructors(event.teachers)}
${formatDateToDateRange(DateTime.parse(event.startDate!), DateTime.parse(event.endDate!))},
At: ${event.locationName ?? event.locationCity}

Check it out here: ${event.url}
-
Found in the AcroWorld app
''';

    Share.share(content);
  }

  String formatDateToDateRange(DateTime start, DateTime end) {
    var formatter = DateFormat('EEE dd.MM.yy');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  String formatInstructors(List<TeacherModel>? teachers) {
    if (teachers == null || teachers.isEmpty) {
      return "";
    }
    if (teachers.length <= 3) {
      if (teachers.length == 1) {
        return "By ${teachers[0].name!}";
      } else if (teachers.length == 2) {
        return "By " '${teachers[0].name!} and ${teachers[1].name!}';
      } else {
        return "By "
            '${teachers[0].name!}, ${teachers[1].name!} and ${teachers[2].name!}';
      }
    } else {
      return "By "
          '${teachers[0].name!}, ${teachers[1].name!}, ${teachers[2].name!}, and more';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.event.isInitiallyBookmarket != null) {
      actions.add(
        ValueListenableBuilder<double>(
          valueListenable: _percentageCollapsed,
          builder: (context, percentage, child) {
            return BackDropActionRowEvent(
                isCollapsed: percentage > appBarCollapsedThreshold,
                eventId: widget.event.id!,
                initialyBookmarked: widget.event.isInitiallyBookmarket,
                shareEvents: () => shareEvent(widget.event));
          },
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: widget.event.pretixName != null
          ? BottomAppBar(
              elevation: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomButton(
                    "Book via AcroWorld",
                    () => customLaunch(
                        "https://booking.acroworld.de/${widget.event.pretixName!}"),
                  ),
                ),
              ),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          CustomSliverAppBar(
            actions: actions,
            percentageCollapsed: _percentageCollapsed,
            headerText: widget.event.name ?? "",
            imgUrl: widget.event.mainImageUrl ?? "",
          ),
          SliverToBoxAdapter(
            child: SingleEventBody(
              event: widget.event,
            ),
          ),
        ],
      ),
    );
  }
}
