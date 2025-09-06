import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for jobs functionality
class JobsState {
  final List<JobModel> jobs;
  final bool loading;
  final bool canFetchMore;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final String selectedFilter; // 'all' or 'active'

  const JobsState({
    this.jobs = const [],
    this.loading = false,
    this.canFetchMore = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedFilter = 'all',
  });

  JobsState copyWith({
    List<JobModel>? jobs,
    bool? loading,
    bool? canFetchMore,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      loading: loading ?? this.loading,
      canFetchMore: canFetchMore ?? this.canFetchMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

/// Job model for jobs functionality
class JobModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'inactive', 'completed'
  final double payRate;
  final String currency;
  final String? imageUrl;
  final String teacherId;
  final String teacherName;
  final String teacherImageUrl;

  const JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.payRate,
    required this.currency,
    this.imageUrl,
    required this.teacherId,
    required this.teacherName,
    this.teacherImageUrl = '',
  });
}

/// Jobs provider notifier
class JobsNotifier extends StateNotifier<JobsState> {
  JobsNotifier() : super(const JobsState());

  /// Fetch jobs with search and filter
  Future<void> fetchJobs({
    String? searchQuery,
    String? filter,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      state = state.copyWith(loading: true, error: null);
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      // TODO: Implement actual GraphQL query for jobs
      // For now, return mock data
      await Future.delayed(const Duration(seconds: 1));
      
      final mockJobs = _generateMockJobs();
      
      state = state.copyWith(
        jobs: isRefresh ? mockJobs : [...state.jobs, ...mockJobs],
        loading: false,
        isLoadingMore: false,
        canFetchMore: mockJobs.length >= 10, // Mock pagination
        searchQuery: searchQuery ?? state.searchQuery,
        selectedFilter: filter ?? state.selectedFilter,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update filter
  void updateFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Fetch more jobs (pagination)
  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.canFetchMore) return;
    
    await fetchJobs(
      searchQuery: state.searchQuery,
      filter: state.selectedFilter,
    );
  }

  /// Generate mock jobs for development
  List<JobModel> _generateMockJobs() {
    return List.generate(10, (index) {
      final now = DateTime.now();
      return JobModel(
        id: 'job_$index',
        title: 'Acro Workshop ${index + 1}',
        description: 'Join us for an amazing acro workshop with professional instruction.',
        location: 'Berlin, Germany',
        startDate: now.add(Duration(days: index * 7)),
        endDate: now.add(Duration(days: index * 7 + 1)),
        status: index % 3 == 0 ? 'active' : 'inactive',
        payRate: 50.0 + (index * 10),
        currency: 'EUR',
        imageUrl: 'https://picsum.photos/400/300?random=$index',
        teacherId: 'teacher_$index',
        teacherName: 'Teacher ${index + 1}',
        teacherImageUrl: 'https://picsum.photos/100/100?random=${index + 100}',
      );
    });
  }
}

/// Jobs provider
final jobsProvider = StateNotifierProvider<JobsNotifier, JobsState>((ref) {
  return JobsNotifier();
});
