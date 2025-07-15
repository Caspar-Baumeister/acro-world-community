import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Text(
                error,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StandartButton(
                  text: "Back to Home", onPressed: () => context.goNamed("/"))
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorScreenWidget extends StatelessWidget {
  const ErrorScreenWidget({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            StandartButton(
                text: "Back to Home", onPressed: () => context.goNamed("/"))
          ],
        ),
      ),
    );
  }
}
