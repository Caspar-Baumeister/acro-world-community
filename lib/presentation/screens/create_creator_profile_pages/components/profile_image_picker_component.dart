import 'dart:typed_data';

import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePickerComponent extends StatefulWidget {
  final Uint8List? profileImage;
  final String? currentImage;
  final Function(Uint8List) onImageSelected;

  const ProfileImagePickerComponent({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
    this.currentImage,
  });

  @override
  ProfileImagePickerComponentState createState() =>
      ProfileImagePickerComponentState();
}

class ProfileImagePickerComponentState
    extends State<ProfileImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        widget.onImageSelected(imageBytes);
      }
    } catch (e) {
      showErrorToast('Error picking profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.avatarSizeMedium * 2,
      height: AppDimensions.avatarSizeMedium * 2,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Container(
              width: AppDimensions.avatarSizeMedium * 2,
              height: AppDimensions.avatarSizeMedium * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors
                      .inactiveBorderColor, // Your desired border color
                  width: 2.0, // Adjust the width of the border as needed
                ),
              ),
              child: widget.currentImage != null
                  ? CustomAvatarCachedNetworkImage(
                      imageUrl: widget.currentImage!,
                      radius: AppDimensions.avatarSizeMedium,
                    )
                  : CircleAvatar(
                      backgroundColor: CustomColors.backgroundColor,
                      radius: AppDimensions.avatarSizeMedium,
                      backgroundImage: widget.profileImage != null
                          ? MemoryImage(widget.profileImage!)
                          : null,
                      child: widget.profileImage == null
                          ? const Icon(Icons.person,
                              size: AppDimensions.avatarSizeMedium,
                              color: CustomColors.iconColor)
                          : null,
                    ),
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: CustomColors.iconColor,
                radius: AppDimensions.iconSizeTiny,
                child: Icon(Icons.camera_alt,
                    color: Colors.white, size: AppDimensions.iconSizeTiny),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
