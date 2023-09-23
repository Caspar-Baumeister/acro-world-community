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

class SingleClassPage extends StatefulWidget {
  const SingleClassPage({Key? key, required this.clas, this.classEvent})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
                // actions: widget.classEvent != null
                //     ? [
                //         ValueListenableBuilder<double>(
                //           valueListenable: _percentageCollapsed,
                //           builder: (context, percentage, child) {
                //             return IconButton(
                //               icon: const Icon(Icons.calendar_month_outlined),
                //               color: percentage > 0.5
                //                   ? Colors.black
                //                   : Colors.white,
                //               onPressed: () => add2CalendarFunction(
                //                   widget.clas.name!,
                //                   widget.clas.description!,
                //                   widget.clas.locationName ?? "unknown",
                //                   DateTime.parse(widget.classEvent!.startDate!),
                //                   DateTime.parse(widget.classEvent!.endDate!)),
                //             );
                //           },
                //         ),
                //       ]
                //     : [],
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
