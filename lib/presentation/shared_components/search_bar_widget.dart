import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/core/utils/decorators.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {required this.onChanged, super.key, this.autofocus = false});

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
    final style = controller.text != ""
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.titleLarge;
    return Container(
      height: INPUTFIELD_HEIGHT,
      decoration: searchBarDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        controller: controller,
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search,
          ),
          suffixIcon: controller.text != ""
              ? GestureDetector(
                  child: const Icon(
                    Icons.close,
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
