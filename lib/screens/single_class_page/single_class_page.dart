import 'package:acroworld/components/wrapper/favorite_class_mutation_widget.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/screens/single_class_page/widgets/booking_query_wrapper.dart';
import 'package:acroworld/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/find_billing_teacher.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  void shareEvent(ClassEvent classEvent, ClassModel clas) {
    final String content = '''
${clas.name}

${formatInstructors(clas.classTeachers)}
${formatDateRangeForInstructor(DateTime.parse(classEvent.startDate!), DateTime.parse(classEvent.endDate!))}
At: ${clas.locationName}
-
Found in the AcroWorld app
''';

    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    print("single class page build");
    final ClassTeachers? billingTeacher =
        findFirstTeacherOrNull(widget.clas.classTeachers);

    print("billingTeacher: $billingTeacher");
    List<Widget> actions = [];
    if (widget.clas.isInitiallyFavorized != null) {
      actions.add(
        ValueListenableBuilder<double>(
          valueListenable: _percentageCollapsed,
          builder: (context, percentage, child) {
            return FavoriteClassMutationWidget(
                classId: widget.clas.id!,
                initialFavorized: widget.clas.isInitiallyFavorized == true,
                color: percentage > appBarCollapsedThreshold
                    ? Colors.black
                    : Colors.white);
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
                    color: percentage > appBarCollapsedThreshold
                        ? Colors.black
                        : Colors.white));
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
              _buildSliverAppBar(context, _percentageCollapsed.value),
              SliverToBoxAdapter(
                child: SingleClassBody(
                  classe: widget.clas,
                  classEvent: widget.classEvent,
                ),
              ),
            ],
          ),
          _buildBottomHoverButton(context, billingTeacher),
        ],
      ),
    );
  }

  Widget _buildBottomHoverButton(
      BuildContext context, ClassTeachers? billingTeacher) {
    if (widget.classEvent != null) {
      return _buildBookingQueryHoverButton(context, billingTeacher);
    } else {
      return _buildCalendarButton(context);
    }
  }

  Widget _buildBookingQueryHoverButton(
      BuildContext context, ClassTeachers? billingTeacher) {
    if (widget.classEvent!.classModel?.classBookingOptions != null &&
        widget.classEvent!.classModel!.classBookingOptions!.isNotEmpty &&
        billingTeacher != null) {
      return BookingQueryHoverButton(classEvent: widget.classEvent!);
    } else {
      return Container();
    }
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

  Widget _buildSliverAppBar(BuildContext context, double percentage) {
    return SliverAppBar(
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color:
            percentage > appBarCollapsedThreshold ? Colors.black : Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      title: percentage > appBarCollapsedThreshold
          ? Text(
              widget.clas.name ?? "",
              maxLines: 1,
              style: H20W5,
              overflow: TextOverflow.fade,
            )
          : Container(), // Empty container when expanded
      actions: [
        FavoriteClassMutationWidget(
            classId: widget.clas.id!,
            initialFavorized: widget.clas.isInitiallyFavorized == true,
            color: percentage > appBarCollapsedThreshold
                ? Colors.black
                : Colors.white),
        IconButton(
            onPressed: () => shareEvent(widget.classEvent!, widget.clas),
            icon: Icon(Icons.ios_share,
                color: percentage > appBarCollapsedThreshold
                    ? Colors.black
                    : Colors.white)),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
      expandedHeight: appBarExpandedHeight,
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
    );
  }
}
