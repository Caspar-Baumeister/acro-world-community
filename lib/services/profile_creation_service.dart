import 'dart:typed_data';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProfileCreationService {
  final GraphQLClient client;

  ProfileCreationService(this.client);

  Future<String> uploadProfileImage(Uint8List image) async {
    return await _uploadImage(image,
        path: 'profile_images/${DateTime.now().millisecondsSinceEpoch}.png');
  }

  Future<List<String>> uploadAdditionalImages(List<Uint8List> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      final String imageUrl = await _uploadImage(
        image,
        path:
            'additional_images/${DateTime.now().millisecondsSinceEpoch}_${images.indexOf(image)}.png',
      );
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  Future<void> createTeacherProfile(
    String name,
    String description,
    String urlSlug,
    String profileImageUrl,
    List<String> additionalImageUrls,
  ) async {
    const String mutation = """
    mutation CreateTeacher(\$name: String!, \$description: String!, \$urlSlug: String!, \$type: teacher_type_enum!, \$images: [teacher_images_insert_input!]!) {
      insert_teachers(
        objects: {
          name: \$name,
          description: \$description,
          url_slug: \$urlSlug,
          type: \$type,
          images: { data: \$images }
        }
      ) {
        affected_rows
      }
    }
  """;

    // Construct the list of images
    final List<Map<String, dynamic>> imagesInput = [
      {
        'image': {
          'data': {
            'url': profileImageUrl,
          },
        },
        'is_profile_picture': true,
      },
      ...additionalImageUrls.map((url) => {
            'image': {
              'data': {
                'url': url,
              },
            },
            'is_profile_picture': false,
          }),
    ];

    final Map<String, dynamic> variables = {
      'name': name,
      'description': description,
      'urlSlug': urlSlug,
      'type':
          'Anonymous', // Or use a dynamic value if you want to pass this as a parameter
      'images': imagesInput,
    };

    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables,
      ),
    );

    if (result.hasException) {
      CustomErrorHandler.captureException(result.exception);
      throw Exception('Failed to create teacher profile');
    }
  }

  Future<String> _uploadImage(Uint8List imageBytes,
      {required String path}) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(path);

      final UploadTask uploadTask = storageRef.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/png', // Assuming you are uploading PNG images
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      CustomErrorHandler.captureException(e);
      throw Exception('Error uploading image: $e');
    }
  }
}
