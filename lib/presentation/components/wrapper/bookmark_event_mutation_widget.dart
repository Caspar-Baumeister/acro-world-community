import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class BookmarkEventMutationWidget extends StatefulWidget {
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
  State<BookmarkEventMutationWidget> createState() =>
      _BookmarkEventMutationWidgetState();
}

class _BookmarkEventMutationWidgetState
    extends State<BookmarkEventMutationWidget> {
  late bool isBookmarked;

  @override
  void initState() {
    isBookmarked = widget.initialBookmarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: Mutation(
        options: MutationOptions(
          document: isBookmarked
              ? Mutations.unBookmarkEvent
              : Mutations.bookmarkEvent,
          onCompleted: (dynamic resultData) {
            setState(() {
              isBookmarked = !isBookmarked;
            });
            showSuccessToast(
                "${isBookmarked ? "Added to" : "Removed from"} bookmarks");
          },
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result == null || result.hasException) {
            return Container();
          }
          if (result.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: widget.color,
              ),
            );
          }

          return Consumer<UserProvider>(
            builder: (context, userProvider, child) => IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: widget.color,
              ),
              onPressed: () => isBookmarked
                  ? runMutation({
                      'event_id': widget.eventId,
                      'user_id': userProvider.activeUser!.id!
                    })
                  : runMutation({
                      'event_id': widget.eventId,
                    }),
            ),
          );
        },
      ),
    );
  }
}
