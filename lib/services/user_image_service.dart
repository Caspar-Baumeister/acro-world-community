import 'dart:typed_data';

import 'package:acroworld/data/graphql/mutations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserImageService {
  final GraphQLClient _client;
  final ImageUploadService _imageUploadService;

  UserImageService(this._client, this._imageUploadService);

  /// Upload a user profile image to Firebase Storage
  Future<String> uploadUserImage(Uint8List imageBytes, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'user_images/${userId}_$timestamp.png';

      return await _imageUploadService.uploadImage(imageBytes, path: path);
    } catch (e) {
      throw Exception('Error uploading user image: $e');
    }
  }

  /// Update user's image URL in the database
  Future<String> updateUserImage(String userId, String imageUrl) async {
    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(Mutations.updateUser),
          variables: {
            'id': userId,
            'changes': {'image_url': imageUrl},
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Error updating user image');
      }

      return 'success';
    } catch (e) {
      throw Exception('Error updating user image: $e');
    }
  }

  /// Remove user's profile image (set to null)
  Future<String> removeUserImage(String userId) async {
    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(Mutations.updateUser),
          variables: {
            'id': userId,
            'changes': {'image_url': null},
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Error removing user image');
      }

      return 'success';
    } catch (e) {
      throw Exception('Error removing user image: $e');
    }
  }

  /// Upload image and update user in one operation
  Future<String> uploadAndUpdateUserImage(
      Uint8List imageBytes, String userId) async {
    try {
      // 1. Upload image to Firebase Storage
      final imageUrl = await uploadUserImage(imageBytes, userId);

      // 2. Update user record with new image URL
      await updateUserImage(userId, imageUrl);

      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading and updating user image: $e');
    }
  }

  /// Delete old image from Firebase Storage (optional cleanup)
  Future<void> deleteOldImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return;

      // Extract the path from the URL
      final uri = Uri.parse(imageUrl);
      final path = uri.pathSegments.last;

      // Delete from Firebase Storage
      final Reference ref =
          FirebaseStorage.instance.ref().child('user_images/$path');
      await ref.delete();
    } catch (e) {
      // Don't throw error for cleanup failures
      print('Warning: Could not delete old image: $e');
    }
  }
}

/// Reusable image upload service (extracted from ProfileCreationService)
class ImageUploadService {
  Future<String> uploadImage(Uint8List imageBytes,
      {required String path}) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(path);

      final UploadTask uploadTask = storageRef.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/png',
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
