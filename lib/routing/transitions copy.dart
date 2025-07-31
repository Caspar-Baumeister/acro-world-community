import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kPageTransitionDuration = Duration(milliseconds: 350);
const kMaxBorderRadius = AppDimensions.radiusLarge;

CustomTransitionPage<void> setupPageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from bottom transition for entry
      const beginEntry = Offset(0.0, 1.0);
      const endEntry = Offset.zero;
      // Slide to bottom transition for exit
      const beginExit = Offset.zero;
      const endExit = Offset(0.0, 1.0);
      const curve = Curves.easeOutCubic;

      // Entry animation
      var entryTween = Tween(begin: beginEntry, end: endEntry)
          .chain(CurveTween(curve: curve));
      var entryAnimation = animation.drive(entryTween);

      // Exit animation
      var exitTween =
          Tween(begin: beginExit, end: endExit).chain(CurveTween(curve: curve));
      var exitAnimation = secondaryAnimation.drive(exitTween);

      // Border radius animations
      final borderAnimation = Tween(
        begin: kMaxBorderRadius,
        end: 0.0,
      ).chain(CurveTween(curve: curve)).animate(animation);

      final borderExitAnimation = Tween(
        begin: 0.0,
        end: kMaxBorderRadius,
      ).chain(CurveTween(curve: curve)).animate(secondaryAnimation);

      return SlideTransition(
        position: exitAnimation,
        child: SlideTransition(
          position: entryAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              borderExitAnimation.value == 0.0
                  ? borderAnimation.value
                  : borderExitAnimation.value,
            ),
            child: child,
          ),
        ),
      );
    },
  );
}

// Custom page builder for shell route
CustomTransitionPage<void> shellPageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOutCubic;

      // Scale animation for when setup page is showing/hiding
      var scaleBegin = 1.0;
      var scaleEnd = 0.95;
      var scaleTween = Tween(begin: scaleBegin, end: scaleEnd)
          .chain(CurveTween(curve: curve));
      // Combine both animations for scale
      var scaleAnimation = Tween(
        begin: scaleEnd,
        end: scaleBegin,
      ).chain(CurveTween(curve: curve)).animate(animation);
      var scaleOutAnimation = secondaryAnimation.drive(scaleTween);

      // Opacity animation for when setup page is showing/hiding
      var opacityTween =
          Tween(begin: 1.0, end: 0.6).chain(CurveTween(curve: curve));
      var opacityAnimation = secondaryAnimation.drive(opacityTween);

      // Fade in animation for the shell itself
      var shellFadeTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
      var shellFadeAnimation = animation.drive(shellFadeTween);

      // Combined animation value for border radius
      final borderAnimation = Tween(
        begin: kMaxBorderRadius,
        end: 0.0,
      ).chain(CurveTween(curve: curve)).animate(animation);
      final borderOutAnimation = Tween(
        begin: 0.0,
        end: kMaxBorderRadius,
      ).chain(CurveTween(curve: curve)).animate(secondaryAnimation);

      return FadeTransition(
        opacity: shellFadeAnimation,
        child: ScaleTransition(
          scale: scaleOutAnimation.value == 1.0
              ? scaleAnimation
              : scaleOutAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                borderOutAnimation.value == 0.0
                    ? borderAnimation.value
                    : borderOutAnimation.value,
              ),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

CustomTransitionPage<void> fadePageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // A simple fade transition
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
