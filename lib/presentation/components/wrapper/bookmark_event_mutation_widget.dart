import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookmarkEventMutationWidget extends ConsumerStatefulWidget {
  const BookmarkEventMutationWidget({
    super.key,
    required this.eventId,
    required this.initialBookmarked,
    required this.color,
  });

  final String eventId;
  final bool initialBookmarked;
  final Color color;

  @override
  ConsumerState<BookmarkEventMutationWidget> createState() =>
      _BookmarkEventMutationWidgetState();
}

class _BookmarkEventMutationWidgetState
    extends ConsumerState<BookmarkEventMutationWidget> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.initialBookmarked;
  }

  Future<void> _toggleBookmark(String userId) async {
    final client = GraphQLClientSingleton().client;
    final doc =
        _isBookmarked ? Mutations.unBookmarkEvent : Mutations.bookmarkEvent;

    final vars = <String, dynamic>{
      'event_id': widget.eventId,
      if (_isBookmarked) 'user_id': userId,
    };

    try {
      await client.mutate(MutationOptions(
        document: doc,
        variables: vars,
      ));
      setState(() => _isBookmarked = !_isBookmarked);
      showSuccessToast(
        _isBookmarked ? "Added to bookmarks" : "Removed from bookmarks",
      );
    } catch (e, st) {
      // Assuming you have a global error handler
      showErrorToast("Could not update bookmark. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: ModernSkeleton(width: 20, height: 20)),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (user) {
            final userId = user?.id;
            return SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: widget.color,
                ),
                onPressed:
                    userId == null ? null : () => _toggleBookmark(userId),
                tooltip: _isBookmarked
                    ? "Remove from bookmarks"
                    : "Add to bookmarks",
              ),
            );
          },
        );
  }
}
