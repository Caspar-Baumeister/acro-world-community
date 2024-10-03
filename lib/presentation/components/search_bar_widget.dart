import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({required this.onChanged, super.key, this.color});

  final ValueChanged<String> onChanged;
  final Color? color;

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
    controller.addListener(() {
      widget.onChanged(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputFieldComponent(
      fillColor: widget.color,
      textInputAction: TextInputAction.search,
      labelText: "Search...",
      leadingIcon: const Icon(Icons.search),
      autoFocus: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      controller: controller,
      suffixIcon: controller.text != ""
          ? GestureDetector(
              child: const Icon(
                Icons.close,
              ),
              onTap: () {
                controller.clear();
                widget.onChanged('');
              },
            )
          : null,
    );
  }
}
