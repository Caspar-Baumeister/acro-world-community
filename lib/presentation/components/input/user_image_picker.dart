import 'dart:typed_data';

import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerComponent extends StatefulWidget {
  final String? currentImageUrl;
  final Function(String)? onImageUrlChanged;
  final Function(Uint8List)? onImageSelected;
  final Function()? onImageRemoved;
  final double size;
  final bool showEditIcon;
  final bool showRemoveButton;
  final bool isLoading;

  const UserImagePickerComponent({
    super.key,
    this.currentImageUrl,
    this.onImageUrlChanged,
    this.onImageSelected,
    this.onImageRemoved,
    this.size = 100.0,
    this.showEditIcon = true,
    this.showRemoveButton = true,
    this.isLoading = false,
  });

  @override
  UserImagePickerComponentState createState() =>
      UserImagePickerComponentState();
}

class UserImagePickerComponentState extends State<UserImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;

  Future<void> _pickImage() async {
    if (widget.isLoading) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = imageBytes;
        });

        // Notify parent components
        widget.onImageSelected?.call(imageBytes);
      }
    } catch (e) {
      showErrorToast('Error picking image: $e');
    }
  }

  void _removeImage() {
    if (widget.isLoading) return;

    setState(() {
      _selectedImageBytes = null;
    });

    widget.onImageRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage =
        widget.currentImageUrl != null || _selectedImageBytes != null;

    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      child: Stack(
        children: [
          // Main image container
          GestureDetector(
            onTap: widget.isLoading ? null : _pickImage,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 2.0,
                ),
              ),
              child: _buildImageContent(theme),
            ),
          ),

          // Loading overlay
          if (widget.isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            ),

          // Edit icon
          if (widget.showEditIcon && !widget.isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.isLoading ? null : _pickImage,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  radius: widget.size * 0.15,
                  child: Icon(
                    Icons.camera_alt,
                    color: theme.colorScheme.onPrimary,
                    size: widget.size * 0.2,
                  ),
                ),
              ),
            ),

          // Remove button (only show if there's an image and not loading)
          if (hasImage && widget.showRemoveButton && !widget.isLoading)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: _removeImage,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.error,
                  radius: widget.size * 0.12,
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onError,
                    size: widget.size * 0.15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent(ThemeData theme) {
    // Show selected image bytes if available
    if (_selectedImageBytes != null) {
      return CircleAvatar(
        backgroundColor: theme.colorScheme.surface,
        radius: widget.size / 2,
        backgroundImage: MemoryImage(_selectedImageBytes!),
      );
    }

    // Show current image URL if available
    if (widget.currentImageUrl != null) {
      return CustomAvatarCachedNetworkImage(
        imageUrl: widget.currentImageUrl!,
        radius: widget.size / 2,
      );
    }

    // Show default placeholder
    return CircleAvatar(
      backgroundColor: theme.colorScheme.surface,
      radius: widget.size / 2,
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// Compact version for smaller displays (like user lists)
class CompactUserImagePicker extends StatelessWidget {
  final String? currentImageUrl;
  final Function(Uint8List)? onImageSelected;
  final double size;
  final bool isLoading;

  const CompactUserImagePicker({
    super.key,
    this.currentImageUrl,
    this.onImageSelected,
    this.size = 40.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isLoading ? null : () => _pickImage(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 1.0,
          ),
        ),
        child: _buildImageContent(theme),
      ),
    );
  }

  Widget _buildImageContent(ThemeData theme) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (currentImageUrl != null) {
      return CustomAvatarCachedNetworkImage(
        imageUrl: currentImageUrl!,
        radius: size / 2,
      );
    }

    return CircleAvatar(
      backgroundColor: theme.colorScheme.surface,
      radius: size / 2,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        onImageSelected?.call(imageBytes);
      }
    } catch (e) {
      showErrorToast('Error picking image: $e');
    }
  }
}
