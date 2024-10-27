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
import 'package:fl_chart/fl_chart.dart';
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

class ParticipantsStatistics extends StatelessWidget {
  const ParticipantsStatistics({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  @override
  Widget build(BuildContext context) {
    final userGenders = bookings
        .where((element) => element.user.gender?.name != null)
        .map((booking) => booking.user.gender!.name!)
        .toList();

    final userLevels = bookings
        .where((element) => element.user.level?.name != null)
        .map((booking) => booking.user.level!.name!)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(AppPaddings.small),
      child: Row(
        children: [
          Flexible(child: ModelPieChart(modelNames: userGenders)),
          Flexible(child: ModelPieChart(modelNames: userLevels)),
        ],
      ),
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

class ModelPieChart extends StatelessWidget {
  final List<String> modelNames; // List with possible duplicate names

  const ModelPieChart({super.key, required this.modelNames});

  @override
  Widget build(BuildContext context) {
    final data = _calculateData(); // Calculate summed data

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _generateSections(context, data),
              sectionsSpace: 2,
              centerSpaceRadius: 20,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        _buildLegend(data, context),
      ],
    );
  }

  Map<String, double> _calculateData() {
    // Count occurrences of each name
    final Map<String, double> dataMap = {};
    for (var name in modelNames) {
      if (dataMap.containsKey(name)) {
        dataMap[name] = dataMap[name]! + 1;
      } else {
        dataMap[name] = 1;
      }
    }
    return dataMap;
  }

  List<PieChartSectionData> _generateSections(
      BuildContext context, Map<String, double> data) {
    // Calculate total count
    final double total = data.values.reduce((a, b) => a + b);

    // Generate pie sections with percentage values
    return data.entries.map((entry) {
      final name = entry.key;
      final count = entry.value;
      final percentage = (count / total) * 100;

      return PieChartSectionData(
        color: Colors.primaries[
            data.keys.toList().indexOf(name) % Colors.primaries.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: Theme.of(context).textTheme.labelMedium,
        radius: 50,
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> data, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: data.entries.map((entry) {
        final name = entry.key;
        final color = Colors.primaries[
            data.keys.toList().indexOf(name) % Colors.primaries.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}
