import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_page_app_bar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_page_view.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: const FilterPageAppBar(), child: SingleChildScrollView(child: FilterPageView()));
  }
}