import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.buttonContent});

  final bool isLoading;
  final void Function() onPressed;
  final Widget buttonContent;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : buttonContent),
    );
  }
}
