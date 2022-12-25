import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.onRefresh}) : super(key: key);
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ??
          () async {
            return;
          },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: CircularProgressIndicator(),
                // child: Image(
                //   image: AssetImage("assets/muscleup_drawing.png"),
                //   height: 200,
                //   fit: BoxFit.contain,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
