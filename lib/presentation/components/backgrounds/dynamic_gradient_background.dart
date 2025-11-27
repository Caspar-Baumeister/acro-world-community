import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that creates a dynamic gradient background based on image colors
class DynamicGradientBackground extends ConsumerWidget {
  const DynamicGradientBackground({
    super.key,
    required this.coverUrl,
    required this.child,
    this.fallbackColors = const [
      Color.fromRGBO(201, 183, 168, 1),
      Color.fromRGBO(213, 209, 207, 1),
    ],
  });

  final String? coverUrl;
  final Widget child;
  final List<Color> fallbackColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (coverUrl == null || coverUrl!.isEmpty) {
      return _buildFallbackGradient();
    }

    return FutureBuilder<ColorScheme>(
      future: _generateColorScheme(coverUrl!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final colorScheme = snapshot.data!;
          return _buildDynamicGradient(colorScheme);
        }
        
        // Show fallback while loading or on error
        return _buildFallbackGradient();
      },
    );
  }

  Widget _buildDynamicGradient(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildFallbackGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: fallbackColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  /// Generates a ColorScheme from the image
  Future<ColorScheme> _generateColorScheme(String imageUrl) async {
    try {
      final imageProvider = NetworkImage(imageUrl);
      final colorScheme = await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.dark,
      );
      return colorScheme;
    } catch (e) {
      // Return a default color scheme if image processing fails
      return const ColorScheme.dark(
        primary: Color.fromRGBO(201, 183, 168, 1),
        primaryContainer: Color.fromRGBO(213, 209, 207, 1),
      );
    }
  }
}

/// A simplified version that uses a single color with opacity variations
class SimpleDynamicBackground extends ConsumerWidget {
  const SimpleDynamicBackground({
    super.key,
    required this.coverUrl,
    required this.child,
    this.fallbackColor = const Color.fromRGBO(201, 183, 168, 1),
  });

  final String? coverUrl;
  final Widget child;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (coverUrl == null || coverUrl!.isEmpty) {
      return _buildFallbackBackground();
    }

    return FutureBuilder<Color>(
      future: _extractDominantColor(coverUrl!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final color = snapshot.data!;
          return _buildDynamicBackground(color);
        }
        
        return _buildFallbackBackground();
      },
    );
  }

  Widget _buildDynamicBackground(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.4),
            color.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            fallbackColor,
            fallbackColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  /// Extracts a dominant color from the image
  Future<Color> _extractDominantColor(String imageUrl) async {
    try {
      final imageProvider = NetworkImage(imageUrl);
      final colorScheme = await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.dark,
      );
      return colorScheme.primary;
    } catch (e) {
      return fallbackColor;
    }
  }
}
