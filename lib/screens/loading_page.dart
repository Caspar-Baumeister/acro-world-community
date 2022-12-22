import 'package:acroworld/components/custom_button.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, this.onRefresh}) : super(key: key);
  final Function? onRefresh;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RefreshIndicator(
            onRefresh: widget.onRefresh != null
                ? () => widget.onRefresh!()
                : () async {
                    return;
                  },
            child: const Center(
              child: Image(
                image: AssetImage("assets/muscleup_drawing.png"),
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.onRefresh != null
              ? CustomButton(
                  "reload",
                  () async {
                    setState(() {
                      loading = true;
                    });
                    await widget.onRefresh!();
                    setState(() {
                      loading = false;
                    });
                  },
                  loading: loading,
                )
              : Container()
        ],
      ),
    );
  }
}
