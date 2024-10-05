import 'dart:typed_data';

import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/pick_image_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EventImahePickerComponent extends StatefulWidget {
  final Uint8List? currentImage;
  final Function(Uint8List) onImageSelected;
  final String? existingImageUrl;

  const EventImahePickerComponent({
    super.key,
    required this.currentImage,
    required this.onImageSelected,
    this.existingImageUrl,
  });

  @override
  EventImahePickerComponentState createState() =>
      EventImahePickerComponentState();
}

class EventImahePickerComponentState extends State<EventImahePickerComponent> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Ensures the container is always square
      child: GestureDetector(
        onTap: () => customPickImage(_picker, widget.onImageSelected),
        child: Stack(
          children: [
            Container(
              width: double.infinity, // Take up all available width
              height: double.infinity, // Maintain the square aspect ratio
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: AppBorders.defaultRadius,
                border: Border.all(
                  color: CustomColors
                      .inactiveBorderColor, // Your desired border color
                  width: 1.0, // Adjust the width of the border as needed
                ),
              ),
              child: widget.currentImage != null
                  ? ClipRRect(
                      borderRadius: AppBorders
                          .defaultRadius, // Ensures the image has rounded corners
                      child: Image.memory(
                        widget.currentImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : widget.existingImageUrl != null
                      ? ClipRRect(
                          borderRadius: AppBorders
                              .defaultRadius, // Ensures the image has rounded corners
                          child: CustomCachedNetworkImage(
                            imageUrl: widget.existingImageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                          ))
                      : const Icon(
                          Icons.image,
                          size: AppDimensions.eventCreationImageSize,
                          color: CustomColors.iconColor,
                        ),
            ),
            const Positioned(
              bottom: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: CustomColors.iconColor,
                radius: AppDimensions.iconSizeMedium,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: AppDimensions.iconSizeTiny,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
