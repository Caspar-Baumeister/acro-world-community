import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
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
      automaticallyImplyLeading: false,
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  STANDART_ROUNDNESS_STRONG), // Rounded corners
              borderSide: const BorderSide(color: STANDART_BORDER_COLOR),
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            hintText: 'Search...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  STANDART_ROUNDNESS_STRONG), // Rounded corners
              borderSide: const BorderSide(color: STANDART_BORDER_COLOR),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            hintStyle: HINT_INPUT_TEXT,
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
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        } else {
                          _focusNode.requestFocus();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.show');
                        }
                      });
                    },
                    icon: Icon(
                      _controller.text.isNotEmpty
                          ? Icons.close
                          : (_focusNode.hasFocus
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up),
                      color: Colors.black,
                    ))),
        style: ACTIVE_INPUT_TEXT, // Black text
        cursorColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
