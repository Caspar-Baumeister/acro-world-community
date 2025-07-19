import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/custom_sliver_app_bar.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/back_drop_action_row.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/single_class_bottom_hover_button.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/share_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleClassPage extends ConsumerStatefulWidget {
  const SingleClassPage({
    super.key,
    required this.clas,
    this.classEvent,
  });

  final ClassModel clas;
  final ClassEvent? classEvent;

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
    return Scaffold(
      bottomNavigationBar: SingleClassBottomHoverButton(
        clas: widget.clas,
        classEvent: widget.classEvent,
      ),
      body: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: 100.0)
            : const EdgeInsets.all(0.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CustomSliverAppBar(
              actions: [
                ValueListenableBuilder<double>(
                  valueListenable: _percentageCollapsed,
                  builder: (context, percentage, _) {
                    return BackDropActionRow(
                      isCollapsed: percentage > appBarCollapsedThreshold,
                      classId: widget.clas.id!,
                      classObject: widget.clas,
                      shareEvents: () => shareEvent(
                        widget.classEvent,
                        widget.clas,
                      ),
                      classEvent: widget.classEvent,
                      classEventId: widget.classEvent?.id,
                    );
                  },
                ),
              ],
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
  }
}
