import 'dart:typed_data';

import 'package:acroworld/presentation/components/input/user_image_picker.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserImageTestScreen extends ConsumerStatefulWidget {
  const UserImageTestScreen({super.key});

  @override
  ConsumerState<UserImageTestScreen> createState() =>
      _UserImageTestScreenState();
}

class _UserImageTestScreenState extends ConsumerState<UserImageTestScreen> {
  Uint8List? _selectedImageBytes;
  bool _isUploading = false;

  Future<void> _handleImageSelected(Uint8List imageBytes) async {
    setState(() {
      _selectedImageBytes = imageBytes;
    });
  }

  Future<void> _handleImageRemoved() async {
    setState(() {
      _selectedImageBytes = null;
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImageBytes == null) {
      showErrorToast('Please select an image first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final success = await ref
          .read(userNotifierProvider.notifier)
          .uploadAndUpdateImage(_selectedImageBytes!);

      if (success) {
        showSuccessToast('Image uploaded successfully!');
        setState(() {
          _selectedImageBytes = null;
        });
      } else {
        showErrorToast('Failed to upload image');
      }
    } catch (e) {
      showErrorToast('Error uploading image: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final success =
          await ref.read(userNotifierProvider.notifier).removeImage();

      if (success) {
        showSuccessToast('Image removed successfully!');
      } else {
        showErrorToast('Failed to remove image');
      }
    } catch (e) {
      showErrorToast('Error removing image: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Image Test'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Current user info
            userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
              data: (user) {
                if (user == null) {
                  return const Text('No user logged in');
                }

                return Column(
                  children: [
                    Text(
                      'Current User: ${user.name ?? "Unknown"}',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Has Image: ${user.imageUrl != null ? "Yes" : "No"}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (user.imageUrl != null)
                      Text(
                        'Image URL: ${user.imageUrl}',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Image picker
            Text(
              'Profile Image',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            userAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (user) {
                return UserImagePickerComponent(
                  currentImageUrl: user?.imageUrl,
                  onImageSelected: _handleImageSelected,
                  onImageRemoved: _handleImageRemoved,
                  size: 120,
                  showEditIcon: true,
                  showRemoveButton: true,
                  isLoading: _isUploading,
                );
              },
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedImageBytes != null && !_isUploading
                      ? _uploadImage
                      : null,
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Upload Image'),
                ),
                ElevatedButton(
                  onPressed: !_isUploading ? _removeImage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Remove Image'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Selected image preview
            if (_selectedImageBytes != null) ...[
              Text(
                'Selected Image Preview:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: CircleAvatar(
                  backgroundImage: MemoryImage(_selectedImageBytes!),
                ),
              ),
            ],

            const Spacer(),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Instructions:',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Tap the image picker to select an image'),
                  const Text(
                      '2. Tap "Upload Image" to save it to your profile'),
                  const Text(
                      '3. Tap "Remove Image" to delete your profile image'),
                  const Text('4. Check the user info above to see changes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
