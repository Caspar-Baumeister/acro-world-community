import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

class GenderDistributionPieFromClassEventId extends StatelessWidget {
  const GenderDistributionPieFromClassEventId(
      {Key? key, required this.classEventId})
      : super(key: key);

  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: Queries.getAcroRoleAggregatesFromClassEvent,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'class_event_id': classEventId}),
      builder: (QueryResult genderAggregates,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (genderAggregates.hasException) {
          return ErrorWidget(genderAggregates.exception.toString());
        } else if (genderAggregates.isLoading) {
          return const LoadingIndicator();
        } else if (genderAggregates.data != null &&
            genderAggregates.data?["total_aggregate"] != null) {
          num amountFlyer = genderAggregates.data?["flyer_aggregate"]
                  ?["aggregate"]?["count"] ??
              0;
          num amountBase = genderAggregates.data?["base_aggregate"]
                  ?["aggregate"]?["count"] ??
              0;
          num totalAmount = genderAggregates.data?["total_aggregate"]
                  ?["aggregate"]?["count"] ??
              0;
          Map<String, double> dataMap = {
            "Flyer": amountFlyer * 1.0,
            "Base": amountBase * 1.0,
            "Not choosen": totalAmount - (amountFlyer + amountBase) * 1.0,
          };
          return PieChart(
            dataMap: dataMap,
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 0,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
