import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class EditClassDescriptionPage extends StatefulWidget {
  final String initialText;
  final Function(String text) onTextUpdated;

  const EditClassDescriptionPage({
    super.key,
    required this.initialText,
    required this.onTextUpdated,
  });

  @override
  EditClassDescriptionPageState createState() =>
      EditClassDescriptionPageState();
}

class EditClassDescriptionPageState extends State<EditClassDescriptionPage> {
  final QuillEditorController _controller = QuillEditorController();
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
    ToolBarStyle.link,
  ];

  @override
  void initState() {
    super.initState();
    _controller.setText(widget.initialText);
  }

  void _applyChanges() {
    _controller.getText().then((text) {
      widget.onTextUpdated(text);
      Navigator.pop(context); // Close the screen after applying changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      makeScrollable: false,
      appBar: AppBar(
        title: Text('Edit Class Description'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToolBar(
              controller: _controller,
              toolBarConfig: customToolBarList,
            ),
            SizedBox(height: 16),
            Expanded(
              child: QuillHtmlEditor(
                  text: widget.initialText,
                  controller: _controller,
                  minHeight: 300,
                  inputAction: InputAction.newline),
            ),
            SizedBox(height: 16),
            StandardButton(
              text: 'SAVE',
              onPressed: _applyChanges,
              isFilled: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
