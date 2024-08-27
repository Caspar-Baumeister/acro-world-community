import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatelessWidget {
  const CustomTabView(
      {super.key,
      this.aboveTabsWidgets,
      required this.tabTitles,
      required this.tabViews});

  final List<Widget>? aboveTabsWidgets;
  final List<String> tabTitles;
  final List<Widget> tabViews;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
