import 'package:acroworld/presentation/components/buttons/standard_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class EditClassDescription extends StatefulWidget {
  final String initialText;
  final Function(String text) onTextUpdated;

  const EditClassDescription({
    super.key,
    required this.initialText,
    required this.onTextUpdated,
  });

  @override
  _EditClassDescriptionState createState() => _EditClassDescriptionState();
}

class _EditClassDescriptionState extends State<EditClassDescription> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Class Description'),
      ),
      body: Padding(
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
              ),
            ),
            SizedBox(height: 16),
            StandardIconButton(
              width: 50,
              text: "Save",
              icon: Icons.save,
              onPressed: _applyChanges,
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
