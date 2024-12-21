import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/custom_button.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/answer_question_modal.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class CheckoutStep extends StatefulWidget {
  const CheckoutStep(
      {super.key,
      required this.className,
      required this.classDate,
      required this.bookingOption,
      required this.previousStep,
      required this.teacherStripeId,
      required this.questions,
      this.classEventId});

  final String className;
  final DateTime classDate;
  final String teacherStripeId;
  final BookingOption bookingOption;
  final Function previousStep;
  final String? classEventId;
  final List<QuestionModel> questions;

  @override
  State<CheckoutStep> createState() => _CheckoutStepState();
}

class _CheckoutStepState extends State<CheckoutStep> {
  bool _ready = false;
  String? paymentIntentId;

  @override
  void initState() {
    super.initState();
    if (widget.bookingOption.id != null && widget.classEventId != null) {
      User? user = Provider.of<UserProvider>(context, listen: false).activeUser;

      if (user == null || user.id == null) {
        showErrorToast(
          "Please redo the login process and try again",
        );
        Navigator.pop(context);
        return;
      }
      initPaymentSheet(widget.bookingOption.id!, widget.classEventId!, user)
          .then((value) {
        setState(() {
          _ready = false;
        });
        User? user =
            Provider.of<UserProvider>(context, listen: false).activeUser;
        if (user != null) {
          Provider.of<EventAnswerProvider>(context, listen: false)
              .initAnswers(user.id!, widget.classEventId!)
              .then(
            (value) {
              setState(() {
                _ready = true;
              });
            },
          );
        }
      });
    } else {
      CustomErrorHandler.captureException(
          Exception(
              "Booking option id or class event id is null when trying to book a class"),
          stackTrace: StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).activeUser!;
    EventAnswerProvider eventAnswerProvider =
        Provider.of<EventAnswerProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              BookingSummarySection(widget: widget),
              const SizedBox(height: 20.0),
              // the same container with information about the user (name, email)
              YourInformationSection(user: user),
              const SizedBox(height: 20.0),
              AnswerSection(
                  question: widget.questions,
                  eventOccurence: widget.classEventId!),
              SizedBox(height: 20.0),

              CustomButton(
                "Continue to payment",
                () async {
                  if (!areRequiredQuestionsAnswered(eventAnswerProvider)) {
                    showErrorToast(
                      "Please answer all required questions",
                    );
                    return;
                  }
                  if (paymentIntentId == null) {
                    showErrorToast(
                      "Something went wrong. Try again later or contact the support",
                    );
                  } else {
                    print("pressed pay");
                    await attemptToPresentPaymentSheet(paymentIntentId!);
                    // mutate the questions trough the eventAnswerProvider
                    eventAnswerProvider.mutateAnswers().then((value) {
                      if (value) {
                        print("Answers mutated");
                      } else {
                        showErrorToast(
                          "Error saving answers, please notify support",
                        );
                      }
                    });
                  }
                },
                loading: !_ready,
                width: double.infinity,
              )
            ],
          ),
        ),
      ],
    );
  }

  // check if required questions are answered
  bool areRequiredQuestionsAnswered(EventAnswerProvider eventAnswerProvider) {
    return eventAnswerProvider.doAllQuestionsHaveAnswers(widget.questions
        .where((element) => element.isRequired == true && element.id != null)
        .map((e) => e.id!)
        .toList());
  }

  Future<void> attemptToPresentPaymentSheet(String paymentIntentId) async {
    try {
      await StripeService(
              stripeRepository:
                  StripeRepository(apiService: GraphQLClientSingleton()))
          .attemptToPresentPaymentSheet(paymentIntentId)
          .then(
        (value) {
          Navigator.of(context).pop();
          // Access the EventBusProvider
          var eventBusProvider =
              Provider.of<EventBusProvider>(context, listen: false);
          // Fire the refetch event for booking query
          eventBusProvider.fireRefetchBookingQuery();
        },
      );
    } on StripeException catch (e) {
      CustomErrorHandler.captureException(e, stackTrace: StackTrace.current);
    }
  }

  Future<void> initPaymentSheet(
      String bookingOptionId, String classEventId, User user) async {
    try {
      StripeService(
              stripeRepository:
                  StripeRepository(apiService: GraphQLClientSingleton()))
          .initPaymentSheet(user, widget.bookingOption, classEventId)
          .then((paymentIntent) {
        if (paymentIntent != null) {
          return setState(() {
            _ready = true;
            paymentIntentId = paymentIntent;
          });
        } else {
          Navigator.pop(context);
          showErrorToast(
            "Error initializing payment, try again later or contact support",
          );
        }
      });
    } catch (e, stackTrace) {
      // show flutter toast with error
      showErrorToast(
        "Error initializing payment, try again later or contact support",
      );

      CustomErrorHandler.captureException(e, stackTrace: stackTrace);
    }
  }
}

class BookingSummarySection extends StatelessWidget {
  const BookingSummarySection({
    super.key,
    required this.widget,
  });

  final CheckoutStep widget;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionContainer(
      child: Column(
        children: [
          // an edit icon in the top right corner
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title of the booking summary
                Flexible(
                  child: Text(
                    "Booking summary for ${widget.className}",
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.previousStep();
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.bookingOption.title}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  widget.bookingOption
                          .realPriceDiscounted()
                          .toStringAsFixed(2) +
                      widget.bookingOption.currency.symbol,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class YourInformationSection extends StatelessWidget {
  const YourInformationSection({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionContainer(
      child: Column(
        children: [
          // an edit icon in the top right corner
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title of the booking summary
                Text(
                  "Your information",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    // route to EditUserdata
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditUserdataPage(),
                        // EditUserdata(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "${user.name}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "${user.email}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Acro level",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  user.level?.name ?? "Not specified",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Acro Role",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  user.gender?.name ?? "Not specified",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

// checkout section container with rounded corners and shadow
class CheckoutSectionContainer extends StatelessWidget {
  const CheckoutSectionContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // round corners and add shadow
      decoration: BoxDecoration(
        color: CustomColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

// another checkoutstep with the same structure
class AnswerSection extends StatelessWidget {
  const AnswerSection({
    super.key,
    required this.question,
    required this.eventOccurence,
  });

  final List<QuestionModel> question;
  final String eventOccurence;

  @override
  Widget build(BuildContext context) {
    if (question.isEmpty) {
      return Container();
    }
    return CheckoutSectionContainer(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.medium,
                    top: AppPaddings.medium,
                    right: AppPaddings.medium),
                child: Text(
                  "Questions from the organizer",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...question.map(
                (e) =>
                    QuestionCard(question: e, eventOccurence: eventOccurence),
              ),
              SizedBox(height: AppPaddings.medium),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final String eventOccurence;

  const QuestionCard(
      {super.key, required this.question, required this.eventOccurence});

  @override
  Widget build(BuildContext context) {
    EventAnswerProvider eventAnswerProvider =
        Provider.of<EventAnswerProvider>(context);

    User? user = Provider.of<UserProvider>(context).activeUser;

    if (user?.id == null) {
      return Container();
    }

    bool hasAnswer = question.id != null
        ? eventAnswerProvider.doesQuestionIdHaveAnswer(question.id!)
        : false;
    return GestureDetector(
      onTap: () {
        buildMortal(
          context,
          AnswerQuestionModal(
              question: question,
              userId: user!.id!,
              eventOccurence: eventOccurence),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPaddings.medium,
          vertical: AppPaddings.small,
        ),
        // error border left and bottom if the question is not answered
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: hasAnswer || question.isRequired == false
                  ? CustomColors.secondaryBackgroundColor
                  : CustomColors.errorBorderColor,
              width: 4.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      question.title ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (question.isRequired == true) ...[
                    SizedBox(width: AppPaddings.small),
                    Text(
                      "(required)",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: hasAnswer
                                ? CustomColors.successBgColor
                                : CustomColors.errorBorderColor,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppPaddings.medium),
            Center(
              child: Icon(
                Icons.arrow_forward_ios,
                size: AppDimensions.iconSizeSmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
