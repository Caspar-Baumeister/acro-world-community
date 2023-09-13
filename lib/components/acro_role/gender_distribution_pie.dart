import 'package:acroworld/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class GenderDistributionPie extends StatelessWidget {
  const GenderDistributionPie({Key? key, required this.users})
      : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    double amountFlyer = 0;
    double amountBase = 0;
    double genderlessAmount = 0;

    for (var user in users) {
      if (user.gender?.id == "dc321f52-fce9-4b00-bef6-e59fb05f4624") {
        amountBase += 1;
      } else if (user.gender?.id == "83a6536f-53ba-44d2-80d9-9842375ebe8b") {
        amountFlyer += 1;
      } else {
        genderlessAmount += 1;
      }
    }

    Map<String, double> dataMap = {
      "Flyer": amountFlyer,
      "Base": amountBase,
      "Not choosen": genderlessAmount,
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
  }
}
