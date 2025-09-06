import 'package:acroworld/presentation/components/sections/analytics_dashboard.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_stripe_connect_button.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/edit_creator_profile_button.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorProfileBody extends ConsumerStatefulWidget {
  const CreatorProfileBody({super.key});

  @override
  ConsumerState<CreatorProfileBody> createState() => _CreatorProfileBodyState();
}

class _CreatorProfileBodyState extends ConsumerState<CreatorProfileBody> {
  // init state runs creatorProvider.setCreatorFromToken

  @override
  void initState() {
    super.initState();
    ref.read(creatorProvider.notifier).setCreatorFromToken();
  }

  @override
  Widget build(BuildContext context) {
    final creatorState = ref.watch(creatorProvider);
    if (creatorState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModernSkeleton(width: 200, height: 20),
            SizedBox(height: 16),
            ModernSkeleton(width: 300, height: 100),
            SizedBox(height: 16),
            ModernSkeleton(width: 250, height: 80),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(creatorProvider.notifier).setCreatorFromToken();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analytics Dashboard
            const AnalyticsDashboard(),
            
            creatorState.activeTeacher != null
                ? EditCreatorProfileButton(
                    teacher: creatorState.activeTeacher!,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.spacingMedium,
              ),
              child: Text("Settings",
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            CreatorStripeConnectButton(),
            SizedBox(height: AppDimensions.spacingLarge),
            
            // Bottom padding to prevent content from being hidden behind floating button
            SizedBox(height: 80), // Space for floating button + padding
          ],
        ),
      ),
    );
  }
}
