import 'package:acroworld/presentation/components/guest_profile_content.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:flutter/material.dart';

void showAuthRequiredDialog(
  BuildContext context, {
  String subtitle =
      'Log in or sign up to access all features and personalize your experience.',
  String? redirectPath,
}) {
  final isDesktop = Responsive.isDesktop(context);

  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      // Adjust inset padding based on device type
      insetPadding: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 40, vertical: 40)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isDesktop
            // For desktop - content-based sizing with constraints
            ? ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  minWidth: 450,
                  maxHeight: 600,
                ),
                child: IntrinsicHeight(
                  child: GuestProfileContent(
                    subtitle: subtitle,
                    redirectPath: redirectPath,
                  ),
                ),
              )
            // For mobile - fixed height based on screen size
            : SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height < 600
                    ? MediaQuery.of(context).size.height * 0.8
                    : MediaQuery.of(context).size.height * 0.7,
                child: GuestProfileContent(
                  subtitle: subtitle,
                  redirectPath: redirectPath,
                ),
              ),
      ),
    ),
  );
}
