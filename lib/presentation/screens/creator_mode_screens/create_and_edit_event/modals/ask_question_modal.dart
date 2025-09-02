import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AskQuestionModal extends ConsumerStatefulWidget {
  const AskQuestionModal({super.key, this.editQuestion});
  final QuestionModel? editQuestion;

  @override
  ConsumerState<AskQuestionModal> createState() => _AskQuestionModalState();
}

class _AskQuestionModalState extends ConsumerState<AskQuestionModal> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isExistingQuestion = false;
  bool _isRequired = false;
  QuestionType _selectedType = QuestionType.text;
  bool _allowMultipleAnswers = false;
  List<TextEditingController> _choiceControllers = [];

  @override
  void initState() {
    super.initState();

    final eventState = ref.read(eventCreationAndEditingProvider);
    _isExistingQuestion = widget.editQuestion != null &&
        eventState.oldQuestions.any((q) => q.id == widget.editQuestion!.id);

    if (widget.editQuestion != null) {
      final question = widget.editQuestion!;
      _questionController.text = question.question ?? "";
      _titleController.text = question.title ?? "";
      _isRequired = question.isRequired ?? false;
      _selectedType = question.type ?? QuestionType.text;
      _allowMultipleAnswers = question.isMultipleChoice ?? false;

      if (_selectedType == QuestionType.multipleChoice &&
          question.choices != null) {
        _choiceControllers = question.choices!
            .map((choice) => TextEditingController(text: choice.optionText))
            .toList();
      }
    }
  }

  void _addChoice() {
    setState(() {
      _choiceControllers.add(TextEditingController());
    });
  }

  void _removeChoice(int index) {
    setState(() {
      _choiceControllers.removeAt(index);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.editQuestion != null) {
      final eventState = ref.read(eventCreationAndEditingProvider);
      _isExistingQuestion = eventState.oldQuestions
          .any((q) => q.id != null && q.id == widget.editQuestion!.id);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _titleController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int newPosition =
        ref.watch(eventCreationAndEditingProvider).questions.length;

    // get the keybord height
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BaseModal(
      title: "Ask a question",
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8 - keyboardHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Question type dropdown
              _isExistingQuestion == true
                  ? Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Question Type: ${widget.editQuestion!.type!.name}"))
                  : DropdownButtonFormField<QuestionType>(
                      value: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                      items: QuestionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: "Question Type"),
                    ),
              const SizedBox(height: 16),
              InputFieldComponent(
                controller: _titleController,
                labelText: _selectedType == QuestionType.phoneNumber
                    ? "Title"
                    : "Question topic",
              ),

              const SizedBox(height: 16),

              /// Question text
              if (_selectedType != QuestionType.phoneNumber)
                InputFieldComponent(
                  controller: _questionController,
                  labelText: "Your question",
                  minLines: 3,
                  maxLines: 8,
                ),

              const SizedBox(height: 16),

              /// Required checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Is this a required question?"),
                  Checkbox(
                    value: _isRequired,
                    onChanged: (value) {
                      setState(() => _isRequired = value ?? false);
                    },
                  ),
                ],
              ),

              /// Multiple choice specific inputs
              if (_selectedType == QuestionType.multipleChoice) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Allow multiple answers?"),
                    Checkbox(
                      value: _allowMultipleAnswers,
                      onChanged: (value) {
                        setState(() => _allowMultipleAnswers = value ?? false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._choiceControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _isExistingQuestion == true
                              ? Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Option ${index + 1}: ${widget.editQuestion!.choices![index].optionText}"))
                              : TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                      labelText: "Option ${index + 1}"),
                                ),
                        ),
                        _isExistingQuestion == true
                            ? const SizedBox()
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeChoice(index),
                              ),
                      ],
                    ),
                  );
                }),
                _isExistingQuestion == true
                    ? const SizedBox()
                    : TextButton.icon(
                        onPressed: _addChoice,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Option"),
                      ),
                const SizedBox(height: 8),
              ],

              const SizedBox(height: 24),

              /// Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StandartButton(
                    width: null,
                    text: "Cancel",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  StandartButton(
                    width: null,
                    text: "Confirm",
                    isFilled: true,
                    onPressed: () {
                      final provider =
                          ref.read(eventCreationAndEditingProvider.notifier);

                      final model = QuestionModel(
                        id: widget.editQuestion?.id ?? Uuid().v4(),
                        question: _questionController.text,
                        title: _titleController.text,
                        isRequired: _isRequired,
                        type: _selectedType,
                        isMultipleChoice:
                            _selectedType == QuestionType.multipleChoice
                                ? _allowMultipleAnswers
                                : null,
                        choices: _selectedType == QuestionType.multipleChoice
                            ? _choiceControllers
                                .map((c) => MultipleChoiceOptionModel(
                                      optionText: c.text,
                                    ))
                                .toList()
                            : null,
                        position: newPosition,
                      );

                      if (widget.editQuestion != null) {
                        if (widget.editQuestion!.id == null) {
                          showErrorToast(
                              "No id for this question. Remove it and create a new one please");
                          return;
                        }
                        provider.editQuestion(widget.editQuestion!.id!, model);
                      } else {
                        provider.addQuestion(model);
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
