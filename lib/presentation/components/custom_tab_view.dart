import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatelessWidget {
  const CustomTabView(
      {super.key,
      this.aboveTabsWidgets,
      required this.tabTitles,
      required this.tabViews,
      this.initialIndex,
      this.onTap});

  final List<Widget>? aboveTabsWidgets;
  final List<String> tabTitles;
  final List<Widget> tabViews;
  final int? initialIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex ?? 0,
      length: tabTitles.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                aboveTabsWidgets ?? [],
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Material(
              child: TabBar(
                onTap: onTap != null ? (value) => onTap!(value) : null,
                labelColor: CustomColors.accentColor,
                unselectedLabelColor: CustomColors.lightestTextColor,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: CustomColors.accentColor,
                tabs: tabTitles.map((title) => Tab(text: title)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: tabViews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
