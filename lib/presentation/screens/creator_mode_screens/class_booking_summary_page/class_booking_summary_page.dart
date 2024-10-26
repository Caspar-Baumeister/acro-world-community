import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/dashboard_single_booking_card.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassBookingSummaryPage extends StatelessWidget {
  const ClassBookingSummaryPage({super.key, required this.classEventId});

  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return BasePage(
        makeScrollable: false,
        appBar: const CustomAppbarSimple(
          title: "Booking Summary for Occurence",
          isBackButton: true,
        ),
        child: ClassBookingSummaryBody(classEventId: classEventId));
  }
}

class ClassBookingSummaryBody extends StatelessWidget {
  const ClassBookingSummaryBody({super.key, required this.classEventId});

  final String classEventId;

  @override
  Widget build(BuildContext context) {
    // Access the UserProvider to get the current user's ID
    UserProvider userProvider = Provider.of<UserProvider>(context);

    if (userProvider.activeUser?.id == null) {
      return const Center(
        child: Text("No user found"),
      );
    }

    final userId = userProvider.activeUser!.id!;

    return FutureBuilder<List<ClassEventBooking>>(
      future: BookingsRepository(apiService: GraphQLClientSingleton())
          .getCreatorsClassEventBookingsByClassEvent(userId, classEventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          CustomErrorHandler.captureException(snapshot.error!,
              stackTrace: snapshot.stackTrace);
          return ErrorWidget(snapshot.error!);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No bookings found for this class"),
          );
        } else {
          return Column(
            children: [
              ParticipantsStatistics(bookings: snapshot.data!),
              Expanded(
                  child:
                      ClassBookingSummaryBookingView(bookings: snapshot.data!))
            ],
          );
        }
      },
    );
  }
}

class ParticipantsStatistics extends StatelessWidget {
  const ParticipantsStatistics({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    final userGenders = bookings.map((booking) => booking.user.gender).toList();
    return Container(
      padding: const EdgeInsets.all(AppPaddings.medium),
      child: 
    );
  }
}

class ClassBookingSummaryBookingView extends StatelessWidget {
  const ClassBookingSummaryBookingView({
    super.key,
    required this.bookings,
  });

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(
              left: AppPaddings.medium,
              right: AppPaddings.medium,
              top: AppPaddings.medium),
          child: DashboardSingleBookingCard(
              booking: booking, isClassBookingSummary: true),
        );
      },
    );
  }
}
