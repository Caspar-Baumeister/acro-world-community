import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/answer_question_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_answer_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_bus_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutStep extends ConsumerStatefulWidget {
  const CheckoutStep({
    super.key,
    required this.className,
    required this.classDate,
    required this.bookingOption,
    required this.previousStep,
    required this.questions,
    this.classEventId,
    this.isDirectPayment,
    this.isCashPayment,
  });

  final String className;
  final DateTime classDate;
  final BookingOption bookingOption;
  final VoidCallback previousStep;
  final String? classEventId;
  final List<QuestionModel> questions;
  final bool? isDirectPayment;
  final bool? isCashPayment;

  @override
  ConsumerState<CheckoutStep> createState() => _CheckoutStepState();
}

class _CheckoutStepState extends ConsumerState<CheckoutStep> {
  bool _isInitAnswersReady = false;
  bool _isPaymentIntentInitialized = false;
  String? paymentIntentId;
  bool hasInitialized = false;

  Future _initializeAll(BuildContext context, WidgetRef ref) async {
    if (hasInitialized) return;
    hasInitialized = true;
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
          ref
              .read(eventAnswerProvider.notifier)
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
    print("is kWeb: $kIsWeb");
    print("is direct payment: ${widget.isDirectPayment}");
    return ref.watch(userRiverpodProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text("Error loading user")),
          data: (user) {
            if (user?.id == null) {
              return const Center(child: Text("Please log in to continue"));
            }
            final eventAnswerState = ref.watch(eventAnswerProvider);
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

                      if (kIsWeb && widget.isDirectPayment == true)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMedium),
                          child: StandartButton(
                            text: "Continue to payment",
                            onPressed: () async {
                              final token = await LocalStorageService.get(
                                  Preferences.token);
                              launchUrl(Uri.parse(
                                  '${Uri.base.scheme}://${Uri.base.authority}/booking/checkout.html?bookingOptionId=${widget.bookingOption.id}&classEventId=${widget.classEventId}&token=$token&dev=${AppEnvironment.isDev ? "true" : "false"}'));
                            },
                            width: double.infinity,
                            isFilled: true,
                          ),
                        ),

                      // if event is bookable troguh direct payment
                      if (widget.isDirectPayment == true && !kIsWeb)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMedium),
                          child: FutureBuilder(
                              future: _initializeAll(context, ref),
                              builder: (context, snapshot) {
                                return StandartButton(
                                  text: "Continue to payment",
                                  onPressed: () async {
                                    if (!areRequiredQuestionsAnswered(ref)) {
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
                                    await attemptToPresentPaymentSheet(
                                        paymentIntentId!);
                                    ref
                                        .read(eventAnswerProvider.notifier)
                                        .mutateAnswers()
                                        .then((ok) {
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
                                );
                              }),
                        ),
                      // if event is bookable through cash payment
                      if (widget.isCashPayment == true)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMedium),
                          child: StandartButton(
                            text: "Pay in cash",
                            onPressed: () async {
                              if (!areRequiredQuestionsAnswered(ref)) {
                                showErrorToast(
                                  "Please answer all required questions",
                                );
                                return;
                              }
                              ref
                                  .read(eventAnswerProvider.notifier)
                                  .mutateAnswers()
                                  .then((ok) async {
                                if (!ok) {
                                  showErrorToast(
                                    "Error saving answers, please notify support",
                                  );
                                } else {
                                  GraphQLClientSingleton client =
                                      GraphQLClientSingleton();
                                  // insert the booking
                                  final result = await client.mutate(
                                    MutationOptions(
                                      document:
                                          Mutations.insertClassEventBooking,
                                      variables: {
                                        "booking": {
                                          "amount": widget.bookingOption
                                                  .realPriceDiscounted() *
                                              100, // convert to cents
                                          "booking_option_id":
                                              widget.bookingOption.id,
                                          "class_event_id": widget.classEventId,
                                          "currency": widget
                                              .bookingOption.currency.value,
                                          "status": "WaitingForPayment",
                                          "user_id": user.id,
                                        },
                                      },
                                    ),
                                  );

                                  if (result.hasException) {
                                    showErrorToast(
                                      "Error booking the class, please try again later",
                                    );
                                    CustomErrorHandler.captureException(
                                      result.exception!,
                                      stackTrace: StackTrace.current,
                                    );
                                    return;
                                  } else {
                                    // show success toast
                                    showSuccessToast(
                                      "Booking successful, please pay in cash at the event",
                                    );
                                  }

                                  // close the modal
                                  Navigator.of(context).pop();
                                  // fire the event to refetch the booking query
                                  ref
                                      .read(eventBusProvider.notifier)
                                      .fireRefetchBookingQuery();
                                }
                              });
                            },
                            width: double.infinity,
                            isFilled: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
  }

  bool areRequiredQuestionsAnswered(WidgetRef ref) {
    return ref.read(eventAnswerProvider.notifier).doAllQuestionsHaveAnswers(
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
        ref.read(eventBusProvider.notifier).fireRefetchBookingQuery();
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
        color: Theme.of(context).colorScheme.surfaceContainer,
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
                    left: AppDimensions.spacingMedium,
                    top: AppDimensions.spacingMedium,
                    right: AppDimensions.spacingMedium),
                child: Text(
                  "Questions from the organizer",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...question.map(
                (e) =>
                    QuestionCard(question: e, eventOccurence: eventOccurence),
              ),
              SizedBox(height: AppDimensions.spacingMedium),
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
        final eventAnswerNotifier = ref.read(eventAnswerProvider.notifier);

        final hasAnswer = question.id != null
            ? eventAnswerNotifier.doesQuestionIdHaveAnswer(question.id!)
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
              horizontal: AppDimensions.spacingMedium,
              vertical: AppDimensions.spacingSmall,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: hasAnswer || !(question.isRequired == true)
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.error,
                  width: 4.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: AppDimensions.spacingSmall),
                  child: hasAnswer
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Theme.of(context).colorScheme.error,
                        ),
                ),
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
                        const SizedBox(width: AppDimensions.spacingSmall),
                        Text(
                          "(required)",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: hasAnswer
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.error,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMedium),
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
