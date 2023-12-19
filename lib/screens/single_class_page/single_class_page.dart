import 'package:acroworld/components/wrapper/favorite_class_mutation_widget.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/screens/single_class_page/widgets/booking_query_wrapper.dart';
import 'package:acroworld/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void shareEvent(ClassEvent classEvent, ClassModel clas) {
    final String content = '''
${clas.name}

${formatInstructors(clas.classTeachers)}
${formatDateRange(DateTime.parse(classEvent.startDate!), DateTime.parse(classEvent.endDate!))}
At: ${clas.locationName}
-
Found in the AcroWorld app
''';

    Share.share(content);
  }

  String formatDateRange(DateTime start, DateTime end) {
    var dayFormatter = DateFormat('EEEE');
    var timeFormatter = DateFormat('HH.mm');
    return '${dayFormatter.format(start)}, ${timeFormatter.format(start)}-${timeFormatter.format(end)}';
  }

  String formatInstructors(List<ClassTeachers>? teachers) {
    if (teachers == null || teachers.isEmpty) {
      return "";
    }
    if (teachers.length <= 3) {
      if (teachers.length == 1) {
        return "By ${teachers[0].teacher!.name!}";
      } else if (teachers.length == 2) {
        return "By "
            '${teachers[0].teacher!.name!} and ${teachers[1].teacher!.name!}';
      } else {
        return "By "
            '${teachers[0].teacher!.name!}, ${teachers[1].teacher!.name!} and ${teachers[2].teacher!.name!}';
      }
    } else {
      return "By "
          '${teachers[0].teacher!.name!}, ${teachers[1].teacher!.name!}, ${teachers[2].teacher!.name!}, and more';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.clas.isInitiallyFavorized != null) {
      actions.add(
        ValueListenableBuilder<double>(
          valueListenable: _percentageCollapsed,
          builder: (context, percentage, child) {
            return FavoriteClassMutationWidget(
                classId: widget.clas.id!,
                initialFavorized: widget.clas.isInitiallyFavorized == true,
                color: percentage > 0.5 ? Colors.black : Colors.white);
          },
        ),
      );
    }
    if (widget.classEvent != null) {
      actions.add(
        ValueListenableBuilder<double>(
          valueListenable: _percentageCollapsed,
          builder: (context, percentage, child) {
            return IconButton(
                onPressed: () => shareEvent(widget.classEvent!, widget.clas),
                icon: Icon(Icons.ios_share,
                    color: percentage > 0.5 ? Colors.black : Colors.white));
          },
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
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
                      return Text(
                        widget.clas.name ?? "",
                        maxLines: 1,
                        style: H20W5,
                        overflow: TextOverflow.fade,
                      );
                    }
                    return Container(); // Empty container when expanded
                  },
                ),
                actions: actions,
                iconTheme: const IconThemeData(color: Colors.white),
                expandedHeight: 200.0,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                  ],
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
                    imageUrl: widget.clas.imageUrl ?? "",
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleClassBody(
                  classe: widget.clas,
                  classEvent: widget.classEvent,
                ),
              ),
            ],
          ),
          widget.classEvent != null
              ? (widget.classEvent?.classModel?.classBookingOptions != null &&
                      widget.classEvent!.classModel!.classBookingOptions!
                          .isNotEmpty &&
                      widget.classEvent?.classModel?.maxBookingSlots != null
                  ? BookingQueryHoverButton(classEvent: widget.classEvent!)
                  : Container())
              : CustomBottomHoverButton(
                  content: const Text(
                    "Class calender",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  // TODO show kalender
                  onPressed: () => buildMortal(
                      context, CalenderModal(classId: widget.clas.id!)),
                )
        ],
      ),
    );
  }
}
