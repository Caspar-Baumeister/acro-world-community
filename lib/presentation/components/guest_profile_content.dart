import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestProfileContent extends StatelessWidget {
  const GuestProfileContent({
    super.key,
    this.subtitle =
        'Log in or sign up to view your saved events and upload yours for free.',
    this.redirectPath,
  });

  final String subtitle;
  final String? redirectPath;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileContent(context),
      desktop: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _buildMobileContent(context),
        ),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      // Remove fixed dimensions for desktop
      width: isDesktop ? null : double.infinity,
      height: isDesktop ? null : double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isDesktop ? 40 : 32,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decorative circle with image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                width: 2.5,
              ),
            ),
            padding:
                const EdgeInsets.all(12), // Padding between border and image
            child: CircleAvatar(
              radius: Responsive.isMobile(context)
                  ? 64 - 12
                  : 80 - 12, // Adjusted for padding
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage(
                'assets/muscleup_drawing.png',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // title
          Text(
            'Create an account or log in',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Responsive.isMobile(context) ? 22 : 26,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          // subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .color!
                  .withOpacity(0.7),
              fontSize: Responsive.isMobile(context) ? 16 : 18,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: Responsive.isMobile(context) ? 32 : 40),

          // Log In button
          SizedBox(
            width: double.infinity,
            height: Responsive.isMobile(context) ? 48 : 65,
            child: ElevatedButton(
              onPressed: () {
                // if you can pop then pop the current page
                if (context.canPop()) {
                  context.pop();
                }
                // Build query parameters with redirect and return action
                final queryParams = <String, String>{
                  'initShowSignIn': 'true',
                };

                if (redirectPath != null) {
                  queryParams['from'] = redirectPath!;
                } else {
                  queryParams['from'] = '/profile';
                }

                context.pushNamed(
                  authRoute,
                  queryParameters: queryParams,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),

          SizedBox(height: Responsive.isMobile(context) ? 12 : 16),

          // Sign Up button
          SizedBox(
            width: double.infinity,
            height: Responsive.isMobile(context) ? 48 : 65,
            child: OutlinedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
                // Build query parameters with redirect and return action
                final queryParams = <String, String>{
                  'initShowSignIn': 'false',
                };

                if (redirectPath != null) {
                  queryParams['from'] = redirectPath!;
                } else {
                  queryParams['from'] = '/profile';
                }

                context.pushNamed(
                  authRoute,
                  queryParameters: queryParams,
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: const StadiumBorder(),
                side: BorderSide.none,
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
