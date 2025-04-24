import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to handle navigation logic
class NavigationNotifier extends Notifier<int> {
  NavigationNotifier();

  @override
  int build() => 1;

  void setIndex(int index) => state = index;
}

final navigationProvider =
    NotifierProvider<NavigationNotifier, int>(NavigationNotifier.new);
