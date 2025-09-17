import 'dart:async';

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
  Timer? _saveTimer;
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

    // Set up periodic saving of description
    _saveTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _saveDescription();
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _saveDescription() async {
    try {
      final text = await _controller.getText();
      ref.read(eventCreationAndEditingProvider.notifier).setDescription(text);
    } catch (e) {
      // Ignore errors during text extraction
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventCreationAndEditingProvider);

    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
        ),
        child: Column(
          children: [
            // Header - compact
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingSmall,
              ),
              child: Column(
                children: [
                  Text(
                    'Event Description',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    'Write a detailed description for your event. Use the toolbar below to format your text.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
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
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
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
                        padding:
                            const EdgeInsets.all(AppDimensions.spacingMedium),
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
                          minHeight: 300,
                          inputAction: InputAction.newline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
