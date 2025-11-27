import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:flutter/material.dart';

/// Modern loading widget that replaces the old LoadingWidget
/// Provides skeleton loading with refresh capability
class ModernLoadingWidget extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final String? message;
  final bool showMessage;

  const ModernLoadingWidget({
    super.key,
    this.onRefresh,
    this.message,
    this.showMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showMessage && message != null) ...[
          ModernSkeleton(width: 200, height: 20),
          const SizedBox(height: 16),
        ],
        ModernSkeleton(
            width: 300,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        const SizedBox(height: 16),
        ModernSkeleton(
            width: 300,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        const SizedBox(height: 16),
        ModernSkeleton(
            width: 250,
            height: 80,
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ],
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(child: content),
          ),
        ),
      );
    }

    return Center(child: content);
  }
}

/// Simple loading widget for basic loading states
class ModernSimpleLoadingWidget extends StatelessWidget {
  final String? message;

  const ModernSimpleLoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (message != null) ...[
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
