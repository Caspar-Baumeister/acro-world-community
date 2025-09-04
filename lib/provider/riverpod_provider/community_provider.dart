import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for community search state
final communitySearchProvider =
    StateNotifierProvider<CommunitySearchNotifier, String>((ref) {
  return CommunitySearchNotifier();
});

/// Provider for community filter state
final communityFilterProvider =
    StateNotifierProvider<CommunityFilterNotifier, String>((ref) {
  return CommunityFilterNotifier();
});

/// State notifier for community search
class CommunitySearchNotifier extends StateNotifier<String> {
  CommunitySearchNotifier() : super('');

  void updateSearch(String search) {
    state = search;
  }

  void clearSearch() {
    state = '';
  }
}

/// State notifier for community filter
class CommunityFilterNotifier extends StateNotifier<String> {
  CommunityFilterNotifier() : super('all');

  void updateFilter(String filter) {
    state = filter;
  }

  bool get isFollowed => state == 'followed';
  bool get isAll => state == 'all';
}

/// Filter options for community page
class CommunityFilters {
  static const List<CommunityFilterOption> options = [
    CommunityFilterOption(
      label: 'All',
      value: 'all',
      icon: null,
    ),
    CommunityFilterOption(
      label: 'Followed',
      value: 'followed',
      icon: null,
    ),
    CommunityFilterOption(
      label: 'Popular',
      value: 'popular',
      icon: null,
    ),
  ];
}

class CommunityFilterOption {
  final String label;
  final String value;
  final IconData? icon;

  const CommunityFilterOption({
    required this.label,
    required this.value,
    this.icon,
  });
}
