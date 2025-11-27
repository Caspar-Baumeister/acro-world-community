import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to handle navigation logic
class NavigationNotifier extends Notifier<int> {
  NavigationNotifier();

  @override
  int build() => 0; // Initial index is 0

  void setIndex(int index) => state = index;
}

final navigationProvider =
    NotifierProvider<NavigationNotifier, int>(NavigationNotifier.new);

// StateNotifier to handle navigation logic
class CreatorNavigationNotifier extends Notifier<int> {
  CreatorNavigationNotifier();

  @override
  int build() => 3; // Initial index is 3

  void setIndex(int index) => state = index;
}

final creatorNavigationProvider =
    NotifierProvider<CreatorNavigationNotifier, int>(
        CreatorNavigationNotifier.new);

// One-time prefetch guard for creator invites badge
final creatorInvitesPrefetchProvider = StateProvider<bool>((ref) => false);
