import 'dart:io';

import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecommendationsBody extends StatefulWidget {
  const RecommendationsBody({Key? key}) : super(key: key);

  @override
  State<RecommendationsBody> createState() => _RecommendationsBodyState();
}

class _RecommendationsBodyState extends State<RecommendationsBody> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const CommingSoon(
      header: "Get the best deals for everything related to acro",
      content:
          "This will be the place where you can shop for books, courses and equipment best suited for acro yogis. We will try to gather the best deals from and for the community",
    );
  }
}
