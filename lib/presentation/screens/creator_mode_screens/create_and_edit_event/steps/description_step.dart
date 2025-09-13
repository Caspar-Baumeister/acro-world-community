import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class DescriptionStep extends ConsumerStatefulWidget {
  const DescriptionStep({super.key, required this.onFinished});

  final Function onFinished;

  @override
  ConsumerState<DescriptionStep> createState() => _DescriptionStepState();
}

class _DescriptionStepState extends ConsumerState<DescriptionStep> {
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
    final eventState = ref.read(eventCreationAndEditingProvider);
    _controller.setText(eventState.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    _controller.getText().then((text) {
      ref.read(eventCreationAndEditingProvider.notifier).setDescription(text);
      widget.onFinished();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Container(
        constraints: Responsive.isDesktop(context)
            ? const BoxConstraints(maxWidth: 800)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingMedium,
                ),
                child: Column(
                  children: [
                    Text(
                      'Event Description',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      'Write a detailed description for your event. Use the toolbar below to format your text.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Rich text editor - takes most of the space
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Toolbar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingSmall,
                          vertical: AppDimensions.spacingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: ToolBar(
                          controller: _controller,
                          toolBarConfig: customToolBarList,
                        ),
                      ),
                      
                      // Editor - flexible height
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: QuillHtmlEditor(
                            text: eventState.description,
                            controller: _controller,
                            minHeight: 200,
                            inputAction: InputAction.newline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingMedium),
              
              // Action buttons with safe area
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingMedium,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: Responsive.isDesktop(context)
                            ? const BoxConstraints(maxWidth: 200)
                            : null,
                        child: ModernButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: "Cancel",
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingMedium),
                      Container(
                        constraints: Responsive.isDesktop(context)
                            ? const BoxConstraints(maxWidth: 400)
                            : null,
                        child: ModernButton(
                          onPressed: _onNext,
                          text: "Next",
                          isFilled: true,
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
