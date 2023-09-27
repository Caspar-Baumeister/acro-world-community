import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/wrapper/bookmark_event_mutation_widget.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/single_event/single_event_body.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class SingleEventPage extends StatefulWidget {
  const SingleEventPage({Key? key, required this.event}) : super(key: key);

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

    const double expandedHeight = 200.0 - kToolbarHeight;
    final double currentHeight =
        200.0 - _scrollController.offset.clamp(0.0, expandedHeight);
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
            return BookmarkEventMutationWidget(
                eventId: widget.event.id!,
                initialBookmarked: widget.event.isInitiallyBookmarket == true,
                color: percentage > 0.5 ? Colors.black : Colors.white);
          },
        ),
      );
    }
    actions.add(
      ValueListenableBuilder<double>(
        valueListenable: _percentageCollapsed,
        builder: (context, percentage, child) {
          return IconButton(
              onPressed: () => shareEvent(widget.event),
              icon: Icon(Icons.ios_share,
                  color: percentage > 0.5 ? Colors.black : Colors.white));
        },
      ),
    );
    return Scaffold(
      bottomNavigationBar: widget.event.pretixName != null
          ? SafeArea(
              child: BottomAppBar(
                height: 60,
                elevation: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: StandartButton(
                      text: "Book via AcroWorld",
                      onPressed: () => customLaunch(
                          "https://booking.acroworld.de${widget.event.pretixName!}"),
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            actions: actions,
            centerTitle: false,
            leading: ValueListenableBuilder<double>(
              valueListenable: _percentageCollapsed,
              builder: (context, percentage, child) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: percentage > 0.5 ? Colors.black : Colors.white,
                  onPressed: () => Navigator.pop(context),
                );
              },
            ),
            title: ValueListenableBuilder<double>(
              valueListenable: _percentageCollapsed,
              builder: (context, percentage, child) {
                if (percentage > 0.5) {
                  return Text(widget.event.name ?? "",
                      maxLines: 3,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18));
                }
                return Container(); // Empty container when expanded
              },
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 200.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
              ],
              // title: Text(clas.name ?? "",
              //     maxLines: 3, style: HEADER_1_TEXT_STYLE),
              background: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 52.0,
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.black12,
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                imageUrl: widget.event.mainImageUrl ?? "",
              ),
            ),
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
