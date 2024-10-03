import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class MarketStep extends StatelessWidget {
  const MarketStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.medium,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
              child: Text(
                  "Here you can create tickets for your event. You can create multiple tickets with different prices and quantities.",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: AppPaddings.medium),
            Center(
                child:
                    StandardButton(onPressed: _onNext, text: 'Create Event')),
            const SizedBox(height: AppPaddings.small),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    onFinished();
  }
}
