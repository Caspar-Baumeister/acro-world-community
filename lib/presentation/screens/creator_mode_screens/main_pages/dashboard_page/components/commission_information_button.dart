import 'package:acroworld/environment.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CommissionInformationButton extends StatelessWidget {
  const CommissionInformationButton({
    super.key,
    required this.symbol,
    required this.price,
  });

  final String symbol;
  final double price;

  @override
  Widget build(BuildContext context) {
    double commission = price * AppEnvironment.commissionPercentage * 0.0001 +
        AppEnvironment.commissionFixedFee;
    return CustomIconButton(
      icon: Icons.info_outline,
      onPressed: () {
        // open pop up with text
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Commission details"),
                  content: Text(
                      """Acroworld partners with Stripe to handle payments. 
Additionaly to the Stripe commission, we also take a small fee for our services.
The total commission is ${AppEnvironment.commissionPercentage}% of the ticket price plus a fixed fee of ${AppEnvironment.commissionFixedFee.toStringAsFixed(2)}$symbol per booking.
For this ticket, the commission is ${commission.toStringAsFixed(2)}$symbol.
          """),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"),
                    )
                  ],
                ));
      },
    );
  }
}
