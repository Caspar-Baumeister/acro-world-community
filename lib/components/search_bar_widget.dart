import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {required this.onChanged, Key? key, this.autofocus = false})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = controller.text != "" ? styleHint : styleActive;
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
        color: Colors.white,
        border: Border.all(color: STANDART_BORDER_COLOR),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: style.color,
          ),
          suffixIcon: controller.text != ""
              ? GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: style.color,
                  ),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    //FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: "search",
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}