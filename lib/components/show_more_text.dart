import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Container(alignment: Alignment.centerLeft, child: Text(firstHalf))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(flag ? ("$firstHalf...") : (firstHalf + secondHalf)),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      flag ? "show more" : "show less",
                      style: const TextStyle(color: LINK_COLOR),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              ),
            ],
          );
  }
}
