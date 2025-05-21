import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/answer_question_modal.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart' as provider;

class CheckoutStep extends ConsumerStatefulWidget {
  const CheckoutStep({
    super.key,
    required this.className,
    required this.classDate,
    required this.bookingOption,
    required this.previousStep,
    required this.teacherStripeId,
    required this.questions,
    this.classEventId,
  });

  final String className;
  final DateTime classDate;
  final String teacherStripeId;
  final BookingOption bookingOption;
  final VoidCallback previousStep;
  final String? classEventId;
  final List<QuestionModel> questions;

  @override
  ConsumerState<CheckoutStep> createState() => _CheckoutStepState();
}

class _CheckoutStepState extends ConsumerState<CheckoutStep> {
  bool _isInitAnswersReady = false;
  bool _isPaymentIntentInitialized = false;
  String? paymentIntentId;

  @override
  void initState() {
    super.initState();
    if (widget.bookingOption.id != null && widget.classEventId != null) {
      // load the current user from Riverpod
      ref.read(userRiverpodProvider.future).then((user) {
        if (user?.id == null) {
          showErrorToast("Please redo the login process and try again");
          Navigator.pop(context);
          return;
        }
        initPaymentSheet(
          widget.bookingOption.id!,
          widget.classEventId!,
          user!,
        ).then((_) {
          provider.Provider.of<EventAnswerProvider>(context, listen: false)
              .initAnswers(user.id!, widget.classEventId!)
              .then((_) {
            setState(() {
              _isInitAnswersReady = true;
            });
          });
        });
      });
    } else {
      CustomErrorHandler.captureException(
        Exception(
          "Booking option id or class event id is null when trying to book a class",
        ),
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text("Error loading user")),
          data: (user) {
            if (user?.id == null) {
              return const Center(child: Text("Please log in to continue"));
            }
            final eventAnswerProvider =
                provider.Provider.of<EventAnswerProvider>(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      BookingSummarySection(widget: widget),
                      const SizedBox(height: 20.0),
                      YourInformationSection(user: user!),
                      const SizedBox(height: 20.0),
                      AnswerSection(
                        question: widget.questions,
                        eventOccurence: widget.classEventId!,
                      ),
                      const SizedBox(height: 20.0),
                      StandartButton(
                        text: "Continue to payment",
                        onPressed: () async {
                          if (!areRequiredQuestionsAnswered(
                              eventAnswerProvider)) {
                            showErrorToast(
                              "Please answer all required questions",
                            );
                            return;
                          }
                          if (paymentIntentId == null) {
                            showErrorToast(
                              "Something went wrong. Try again later or contact support",
                            );
                            return;
                          }
                          await attemptToPresentPaymentSheet(paymentIntentId!);
                          eventAnswerProvider.mutateAnswers().then((ok) {
                            if (!ok) {
                              showErrorToast(
                                "Error saving answers, please notify support",
                              );
                            }
                          });
                        },
                        loading: !_isInitAnswersReady ||
                            !_isPaymentIntentInitialized,
                        width: double.infinity,
                        isFilled: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
  }

  bool areRequiredQuestionsAnswered(EventAnswerProvider eventAnswerProvider) {
    return eventAnswerProvider.doAllQuestionsHaveAnswers(
      widget.questions
          .where((q) => q.isRequired == true && q.id != null)
          .map((q) => q.id!)
          .toList(),
    );
  }

  Future<void> attemptToPresentPaymentSheet(String pi) async {
    try {
      await StripeService(
              stripeRepository:
                  StripeRepository(apiService: GraphQLClientSingleton()))
          .attemptToPresentPaymentSheet(pi)
          .then((_) {
        Navigator.of(context).pop();
        provider.Provider.of<EventBusProvider>(context, listen: false)
            .fireRefetchBookingQuery();
      });
    } on StripeException catch (e) {
      CustomErrorHandler.captureException(
        e,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> initPaymentSheet(
      String bookingOptionId, String classEventId, User user) async {
    try {
      final pi = await StripeService(
              stripeRepository:
                  StripeRepository(apiService: GraphQLClientSingleton()))
          .initPaymentSheet(user, widget.bookingOption, classEventId);
      if (pi != null) {
        setState(() {
          _isPaymentIntentInitialized = true;
          paymentIntentId = pi;
        });
      } else {
        Navigator.pop(context);
        showErrorToast(
          "Error initializing payment, try again later or contact support",
        );
      }
    } catch (e, st) {
      showErrorToast(
        "Error initializing payment, try again later or contact support",
      );
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
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
                    "Booking summary",
                    style: Theme.of(context).textTheme.titleLarge,
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

class QuestionCard extends ConsumerWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.eventOccurence,
  });

  final QuestionModel question;
  final String eventOccurence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current user
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        final userId = user?.id;
        if (userId == null) {
          // Not logged in or no user ID
          return const SizedBox.shrink();
        }

        // The answers provider remains the same
        final eventAnswerProvider =
            provider.Provider.of<EventAnswerProvider>(context);

        final hasAnswer = question.id != null
            ? eventAnswerProvider.doesQuestionIdHaveAnswer(question.id!)
            : false;

        return GestureDetector(
          onTap: () {
            buildMortal(
              context,
              AnswerQuestionModal(
                question: question,
                userId: userId,
                eventOccurence: eventOccurence,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPaddings.medium,
              vertical: AppPaddings.small,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: hasAnswer || !(question.isRequired == true)
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
                        const SizedBox(width: AppPaddings.small),
                        Text(
                          "(required)",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: hasAnswer
                                        ? CustomColors.successBgColor
                                        : CustomColors.errorBorderColor,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppPaddings.medium),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: AppDimensions.iconSizeSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
