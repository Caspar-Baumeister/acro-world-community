import 'dart:io';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PretixWebView extends StatefulWidget {
  const PretixWebView(
      {required this.initialUrl, this.onFinish, Key? key, this.setSuccess})
      : super(key: key);
  final String initialUrl;
  final VoidCallback? onFinish;
  final Function(bool success)? setSuccess;

  @override
  State<PretixWebView> createState() => _PretixWebViewState();
}

class _PretixWebViewState extends State<PretixWebView> {
  late WebViewController controller;
  double process = 0;
  String returnURL = "payment/order-payed";
  String cancelURL = "cancelURL";

  String? accessToken;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "AcroWorld",
            style: HEADER_1_TEXT_STYLE,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: process,
              color: PRIMARY_COLOR,
              backgroundColor: Colors.black12,
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  print("request.url");
                  print(request.url);
                  if (request.url.contains(returnURL)) {
                    widget.onFinish!();
                    Navigator.of(context).pop();
                  }
                  if (request.url.contains(cancelURL)) {
                    Navigator.of(context).pop();
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
