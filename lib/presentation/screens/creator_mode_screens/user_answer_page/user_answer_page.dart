import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/data/repositories/event_forms_repository.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserAnswerPage extends StatelessWidget {
  const UserAnswerPage(
      {super.key, required this.userId, required this.classEventId});

  final String userId;
  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: UserService().getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: CustomAppbarSimple(title: "Answers"),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: CustomAppbarSimple(title: "Error"),
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: CustomAppbarSimple(title: "No user found"),
            body: Center(child: Text("No user found")),
          );
        }

        final User user = snapshot.data!;
        return BasePage(
          makeScrollable: false,
          appBar: CustomAppbarSimple(
            title: "Answers by ${user.name ?? 'User'}",
          ),
          child: UserAnswerBody(
            user: user,
            userId: userId,
            classEventId: classEventId,
          ),
        );
      },
    );
  }
}

class UserAnswerBody extends StatelessWidget {
  const UserAnswerBody(
      {super.key,
      required this.user,
      required this.userId,
      required this.classEventId});

  final User user;
  final String userId;
  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EventFormsRepository(apiService: GraphQLClientSingleton())
          .getQuestionsAndAnswersForUserAndClassEvent(
              userId: userId, classEventId: classEventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(AppPaddings.large),
            child: Text("Error: ${snapshot.error}"),
          ));
        }
        final List<QuestionModel>? questions = snapshot.data?["questions"];
        final List<AnswerModel>? answers = snapshot.data?["answers"];

        if (questions == null || answers == null || questions.isEmpty) {
          return Center(child: Text("No questions found"));
        }

        print("Answers length: ${answers.length}");
        print("Questions length: ${questions.length}");
        print(answers.map((e) => e.toJson()).toList());

        return ListView(
          padding: EdgeInsets.all(AppPaddings.small),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppPaddings.medium),
              child: UserInfoHeader(user: user),
            ),
            SizedBox(height: AppPaddings.medium),
            for (int i = 0; i < questions.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppPaddings.small),
                child: AnswerQuestionCard(
                  question: questions[i],
                  answer: answers.firstWhere(
                    (element) => element.questionId == questions[i].id,
                    orElse: () => AnswerModel(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? "Unknown User",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (user.gender != null && user.level != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppPaddings.small),
                  child: Wrap(spacing: 8, runSpacing: 4, children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.gender!.name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.level!.name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ]),
                ),
              if (user.email != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppPaddings.small),
                  child: Wrap(spacing: 8, runSpacing: 4, children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.email ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnswerQuestionCard extends StatelessWidget {
  const AnswerQuestionCard(
      {super.key, required this.question, required this.answer});

  final QuestionModel question;
  final AnswerModel answer;

  @override
  Widget build(BuildContext context) {
    print(" answer.multipleChoiceAnswers: ${answer.multipleChoiceAnswers}");
    print(" question.choices: ${question.choices}");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.medium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                question.title != null
                    ? (question.title! +
                        (question.isRequired == true ? " *" : ""))
                    : "No topic specified",
                style: Theme.of(context).textTheme.headlineMedium),
            if (question.question != null && question.question!.isNotEmpty) ...[
              SizedBox(height: AppPaddings.small),
              ShowMoreText(text: question.question ?? ""),
            ],
            if (answer.answer != null && answer.answer!.isNotEmpty) ...[
              SizedBox(height: AppPaddings.small),
              Container(
                  padding: EdgeInsets.all(AppPaddings.small),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: CustomColors.secondaryBackgroundColor),
                      color: CustomColors.secondaryBackgroundColor,
                      borderRadius: AppBorders.smallRadius),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (question.type == QuestionType.phoneNumber) ...[
                        Text(answer.countryDialCode ?? ""),
                        SizedBox(width: AppPaddings.small),
                      ],
                      Flexible(child: Text(answer.answer!)),
                      if (question.type == QuestionType.phoneNumber) ...[
                        // copy number to clipboard
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: (answer.countryDialCode ?? "") +
                                    answer.answer!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied to clipboard"),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: AppPaddings.small),
                            child: Icon(
                              Icons.copy,
                              size: 16,
                            ),
                          ),
                        )
                      ]
                    ],
                  )),
            ],
            if (question.type == QuestionType.multipleChoice &&
                question.choices != null &&
                question.choices!.isNotEmpty &&
                answer.multipleChoiceAnswers != null &&
                answer.multipleChoiceAnswers!.isNotEmpty) ...[
              SizedBox(height: AppPaddings.small),
              for (int i = 0; i < question.choices!.length; i++)
                if (answer.multipleChoiceAnswers!.any((element) =>
                    element.multipleChoiceOptionId == question.choices![i].id))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppPaddings.small),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: CustomColors.secondaryBackgroundColor,
                        ),
                        SizedBox(width: AppPaddings.small),
                        Expanded(
                            child: Text(question.choices![i].optionText ?? "")),
                      ],
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class ShowMoreText extends StatefulWidget {
  const ShowMoreText({
    super.key,
    required this.text,
    this.maxNonExpandedLines = 2,
    this.showMoreText = 'Show more',
    this.showLessText = 'Show less',
    this.showMoreStyle,
    this.showLessStyle,
  });

  final String text;
  final int maxNonExpandedLines;

  /// Text for the 'show more' link
  final String showMoreText;

  /// Text for the 'show less' link
  final String showLessText;

  /// Style for the 'show more' link
  final TextStyle? showMoreStyle;

  /// Style for the 'show less' link
  final TextStyle? showLessStyle;

  @override
  State<ShowMoreText> createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool _expanded = false;
  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: _text,
          style: DefaultTextStyle.of(context).style,
        );

        final tp = TextPainter(
          text: textSpan,
          maxLines: widget.maxNonExpandedLines,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);
        final isOverflowing = tp.didExceedMaxLines;

        if (!isOverflowing) {
          return Text(_text);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _expanded
                  ? Text(_text)
                  : Text(
                      _text,
                      maxLines: widget.maxNonExpandedLines,
                      overflow: TextOverflow.ellipsis,
                    ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Text(
                    _expanded ? widget.showLessText : widget.showMoreText,
                    style:
                        _expanded ? widget.showLessStyle : widget.showMoreStyle,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
