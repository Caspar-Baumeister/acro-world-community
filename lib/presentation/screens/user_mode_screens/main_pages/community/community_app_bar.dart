import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;

  const TeacherAppBar({super.key, required this.onSearchChanged});

  @override
  TeacherAppBarState createState() => TeacherAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TeacherAppBarState extends State<TeacherAppBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(_handleFocusChange);
  }

  _onSearchChanged() {
    widget.onSearchChanged(_controller.text);
  }

  void _handleFocusChange() {
    setState(() {}); // Rebuild the widget when focus changes
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_onSearchChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                AppDimensions.radiusMedium), // Rounded corners
            borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.primary), // activeBorderColor
          ),
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onSurface), // black
          hintText: 'Search...',
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface, // white
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                AppDimensions.radiusMedium), // Rounded corners
            borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline), // inactiveBorderColor
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          hintStyle: Theme.of(context).textTheme.titleLarge,
          suffixIcon: !_focusNode.hasFocus && _controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    setState(() {
                      // Wrap state changes in setState
                      if (_controller.text.isNotEmpty) {
                        _controller.clear();
                      } else if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      } else {
                        _focusNode.requestFocus();
                        SystemChannels.textInput.invokeMethod('TextInput.show');
                      }
                    });
                  },
                  icon: Icon(
                    _controller.text.isNotEmpty
                        ? Icons.close
                        : (_focusNode.hasFocus
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                    color: Theme.of(context).colorScheme.onSurface, // black
                  )),
        ),
        style: Theme.of(context).textTheme.titleLarge,
        cursorColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
