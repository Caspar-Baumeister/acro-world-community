import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FavoriteClassMutationWidget extends ConsumerStatefulWidget {
  const FavoriteClassMutationWidget({
    super.key,
    required this.classId,
    required this.initialFavorized,
  });

  final String classId;
  final bool initialFavorized;

  @override
  ConsumerState<FavoriteClassMutationWidget> createState() =>
      _FavoriteClassMutationWidgetState();
}

class _FavoriteClassMutationWidgetState
    extends ConsumerState<FavoriteClassMutationWidget> {
  late bool _isFavorized;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorized = widget.initialFavorized;
  }

  Future<void> _toggleFavorite(String userId) async {
    setState(() => _isLoading = true);
    final client = GraphQLClientSingleton().client;
    final document =
        _isFavorized ? Mutations.unFavoritizeClass : Mutations.favoritizeClass;
    final variables = <String, dynamic>{
      'class_id': widget.classId,
      if (_isFavorized) 'user_id': userId,
    };

    try {
      final result = await client.mutate(
        MutationOptions(document: document, variables: variables),
      );
      if (result.hasException) throw result.exception!;
      setState(() => _isFavorized = !_isFavorized);
      showSuccessToast(
        _isFavorized ? "Added to favorites" : "Removed from favorites",
      );
    } catch (e) {
      showErrorToast("Could not update favorites. Please try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (user) {
            final userId = user?.id;
            return SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isFavorized ? Icons.favorite : Icons.favorite_border,
                        color: Theme.of(context).iconTheme.color,
                      ),
                onPressed: (userId == null || _isLoading)
                    ? null
                    : () => _toggleFavorite(userId),
                tooltip:
                    _isFavorized ? "Remove from favorites" : "Add to favorites",
              ),
            );
          },
        );
  }
}
