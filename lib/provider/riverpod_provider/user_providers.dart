import 'dart:typed_data';

import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/user_image_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final userRiverpodProvider = FutureProvider.autoDispose<User?>((ref) async {
  // 1️⃣ Watch auth state
  final auth = ref.watch(authProvider);
  // If not authenticated, clear any cached data and return null
  if (auth.value?.status != AuthStatus.authenticated ||
      auth.value?.token == null) {
    return null;
  }

  // 2️⃣ Fetch “me” from GraphQL
  try {
    final client = GraphQLClientSingleton().client;
    final result = await client.query(
      QueryOptions(
        document: Queries.getMe,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      // Only logout on authentication errors, not network errors
      if (isAuthenticationError(result.exception)) {
        CustomErrorHandler.logError(
          'Authentication error in getMe query, logging out: ${result.exception}',
        );
        await ref.read(authProvider.notifier).signOut();
      } else {
        // Log network or other errors but don't logout
        CustomErrorHandler.logError(
          'Error fetching user data: ${result.exception}',
        );
      }
      return null;
    }

    final list = result.data?['me'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      // No “me” → sign out
      await ref.read(authProvider.notifier).signOut();
      return null;
    }

    // 3️⃣ Parse and return the User

    return User.fromJson(list.first as Map<String, dynamic>);
  } catch (e, st) {
    CustomErrorHandler.captureException(e.toString(), stackTrace: st);
    return null;
  }
});

class UserNotifier extends AsyncNotifier<User?> {
  late final UserImageService _userImageService;

  @override
  Future<User?> build() {
    _userImageService = UserImageService(
      GraphQLClientSingleton().client,
      ImageUploadService(),
    );
    return ref.watch(userRiverpodProvider.future);
  }

  /// Apply arbitrary field updates
  Future<bool> updateFields(Map<String, dynamic> updates) async {
    final current = state.value;
    if (current == null || updates.isEmpty) return false;

    state = const AsyncValue.loading();

    try {
      final res = await GraphQLClientSingleton().client.mutate(MutationOptions(
            document: gql(Mutations.updateUser),
            variables: {'id': current.id, 'changes': updates},
          ));

      if (res.hasException) {
        throw res.exception!;
      }

      final updatedJson =
          res.data!['update_users_by_pk'] as Map<String, dynamic>;
      final updatedUser = User.fromJson(updatedJson);

      state = AsyncValue.data(updatedUser);
      return true;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      state = AsyncValue.data(current);
      return false;
    }
  }

  /// Upload and update user profile image
  Future<bool> uploadAndUpdateImage(Uint8List imageBytes) async {
    final current = state.value;
    if (current?.id == null) return false;

    state = const AsyncValue.loading();

    try {
      final imageUrl = await _userImageService.uploadAndUpdateUserImage(
        imageBytes,
        current!.id!,
      );

      // Update local state with new image URL
      final updatedUser = User(
        userRoles: current.userRoles,
        name: current.name,
        id: current.id,
        bio: current.bio,
        teacherId: current.teacherId,
        gender: current.gender,
        email: current.email,
        level: current.level,
        imageUrl: imageUrl,
        fcmToken: current.fcmToken,
        teacherProfile: current.teacherProfile,
        isEmailVerified: current.isEmailVerified,
      );

      state = AsyncValue.data(updatedUser);
      return true;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      state = AsyncValue.data(current);
      return false;
    }
  }

  /// Update user image URL (when image is already uploaded)
  Future<bool> updateImageUrl(String imageUrl) async {
    final current = state.value;
    if (current?.id == null) return false;

    state = const AsyncValue.loading();

    try {
      await _userImageService.updateUserImage(current!.id!, imageUrl);

      // Update local state with new image URL
      final updatedUser = User(
        userRoles: current.userRoles,
        name: current.name,
        id: current.id,
        bio: current.bio,
        teacherId: current.teacherId,
        gender: current.gender,
        email: current.email,
        level: current.level,
        imageUrl: imageUrl,
        fcmToken: current.fcmToken,
        teacherProfile: current.teacherProfile,
        isEmailVerified: current.isEmailVerified,
      );

      state = AsyncValue.data(updatedUser);
      return true;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      state = AsyncValue.data(current);
      return false;
    }
  }

  /// Remove user profile image
  Future<bool> removeImage() async {
    final current = state.value;
    if (current?.id == null) return false;

    state = const AsyncValue.loading();

    try {
      await _userImageService.removeUserImage(current!.id!);

      // Update local state with null image URL
      final updatedUser = User(
        userRoles: current.userRoles,
        name: current.name,
        id: current.id,
        bio: current.bio,
        teacherId: current.teacherId,
        gender: current.gender,
        email: current.email,
        level: current.level,
        imageUrl: null,
        fcmToken: current.fcmToken,
        teacherProfile: current.teacherProfile,
        isEmailVerified: current.isEmailVerified,
      );

      state = AsyncValue.data(updatedUser);
      return true;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      state = AsyncValue.data(current);
      return false;
    }
  }

  /// Get current user image URL
  String? get currentImageUrl => state.value?.imageUrl;

  /// Check if user has a profile image
  bool get hasImage => currentImageUrl != null && currentImageUrl!.isNotEmpty;

  /// Get the UserImageService instance (for external use)
  UserImageService get userImageService => _userImageService;
}

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);
