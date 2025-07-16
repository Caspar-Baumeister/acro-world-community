import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:flutter/material.dart';

void showAuthRequiredDialog(
  BuildContext context, {
  String subtitle =
      'Log in or sign up to access all features and personalize your experience.',
}) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        // Reduced from 16 to 12 for slightly more subtle rounding
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        // Also clip the content to match the container shape
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(ctx).size.height * 0.7,
          child: GuestProfileContent(subtitle: subtitle),
        ),
      ),
    ),
  );
}
