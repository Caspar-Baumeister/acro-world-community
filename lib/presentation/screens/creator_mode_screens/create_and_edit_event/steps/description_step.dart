import 'dart:async';

import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_basic_info_provider.dart';
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
  bool _isInitialized = false;
  bool _editorLoaded = false;
  String _lastLoadedDescription = '';

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.strike,
    ToolBarStyle.size,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.align,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.link,
    ToolBarStyle.image,
    ToolBarStyle.video,
    ToolBarStyle.blockQuote,
    ToolBarStyle.codeBlock,
    ToolBarStyle.indentMinus,
    ToolBarStyle.indentAdd,
    ToolBarStyle.directionRtl,
    ToolBarStyle.directionLtr,
    ToolBarStyle.clean,
    ToolBarStyle.clearHistory,
    ToolBarStyle.undo,
    ToolBarStyle.redo,
  ];

  @override
  void initState() {
    super.initState();

    // Listen for when editor is loaded
    _controller.onEditorLoaded(() {
      _editorLoaded = true;
      _loadInitialDescription();
    });

    // Set up periodic saving of description
    _saveTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _saveDescription();
    });
  }

  void _loadInitialDescription() async {
    if (_isInitialized || !_editorLoaded) return;

    final basicInfo = ref.read(eventBasicInfoProvider);
    if (basicInfo.description.isNotEmpty) {
      await _controller.setText(basicInfo.description);
      _lastLoadedDescription = basicInfo.description;
      _isInitialized = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only update if description changed from external source (e.g., template load)
    final basicInfo = ref.watch(eventBasicInfoProvider);

    if (basicInfo.description.isNotEmpty &&
        basicInfo.description != _lastLoadedDescription &&
        _isInitialized &&
        _editorLoaded) {
      // Description changed from external source, update editor
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _controller.setText(basicInfo.description);
        _lastLoadedDescription = basicInfo.description;
      });
    }
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
      ref.read(eventBasicInfoProvider.notifier).setDescription(text);
    } catch (e) {
      // Ignore errors during text extraction
    }
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = ref.watch(eventBasicInfoProvider);

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
            // Rich text editor - takes all available space
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
                    // Toolbar - scrollable
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingSmall,
                          vertical: AppDimensions.spacingSmall,
                        ),
                        child: IntrinsicWidth(
                          child: ToolBar(
                            controller: _controller,
                            toolBarConfig: customToolBarList,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            toolBarColor: Colors.transparent,
                            mainAxisSize: MainAxisSize.min,
                          ),
                        ),
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
                          text: basicInfo.description,
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
