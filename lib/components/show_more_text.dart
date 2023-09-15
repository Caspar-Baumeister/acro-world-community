import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  const DescriptionTextWidget(
      {Key? key, required this.text, this.isHeader = false})
      : super(key: key);
  final String text;
  final bool isHeader;

  @override
  DescriptionTextWidgetState createState() => DescriptionTextWidgetState();
}

class DescriptionTextWidgetState extends State<DescriptionTextWidget> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isHeader
            ? const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Description",
                  textAlign: TextAlign.start,
                  style: H20W3,
                ),
              )
            : Container(),
        secondHalf.isEmpty
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
                          flag ? "read more" : "fold in",
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
              ),
      ],
    );
  }
}
