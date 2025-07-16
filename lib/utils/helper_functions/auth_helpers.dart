import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:flutter/material.dart';

void showAuthRequiredDialog(
  BuildContext context, {
  String subtitle =
      'Log in or sign up to access all features and personalize your experience.',
}) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.height < 600;

  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      // Adjust inset padding based on device type
      insetPadding: Responsive.isMobile(context)
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          // Adjust height based on screen size
          height: Responsive.isMobile(context)
              ? isSmallScreen
                  ? screenSize.height * 0.8 // Small mobile devices
                  : screenSize.height * 0.7 // Regular mobile devices
              : screenSize.height * 0.85, // Desktop devices
          // On desktop, constrain the width for better readability
          child: Responsive(
            mobile: GuestProfileContent(subtitle: subtitle),
            desktop: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: GuestProfileContent(subtitle: subtitle),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
