import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/class_booking_summary_booking_view.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/participants_statistics.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              SizedBox(
                  height: 200,
                  child: ParticipantsStatistics(bookings: snapshot.data!)),
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
