import 'dart:typed_data';

import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalImagePickerComponent extends StatefulWidget {
  final List<Uint8List> additionalImages;
  final Function(List<Uint8List>) onImagesSelected;
  final List<String> currentImages;
  // remove images from the list
  final Function(int, bool) onImageRemoved;

  const AdditionalImagePickerComponent({
    super.key,
    required this.additionalImages,
    required this.onImagesSelected,
    required this.currentImages,
    required this.onImageRemoved,
  });

  @override
  AdditionalImagePickerComponentState createState() =>
      AdditionalImagePickerComponentState();
}

class AdditionalImagePickerComponentState
    extends State<AdditionalImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();
  final additionalImageRowController = ScrollController();

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<Uint8List> images = await Future.wait(
          pickedFiles.map((file) => file.readAsBytes()),
        );
        widget.onImagesSelected(images);
        await Future.delayed(const Duration(milliseconds: 300));
        additionalImageRowController.animateTo(
          additionalImageRowController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      showErrorToast('Error picking additional images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(AppDimensions.spacingSmall).copyWith(top: 0),
      decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.inactiveBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Additional Images'),
              IconButton(onPressed: _pickImages, icon: const Icon(Icons.add)),
            ],
          ),
          widget.additionalImages.isEmpty && widget.currentImages.isEmpty
              ? Center(
                  child: Text('No additional images selected',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: CustomColors.primaryTextColor,
                          )),
                )
              : SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    controller: additionalImageRowController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (widget.currentImages.isNotEmpty)
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.currentImages.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(
                                  AppDimensions.spacingSmall),
                              child: ImageCard(
                                imageUrl: widget.currentImages[index],
                                onImageRemoved: () {
                                  widget.onImageRemoved(index, true);
                                },
                              ),
                            ),
                          ),
                        if (widget.additionalImages.isNotEmpty)
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.additionalImages.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(
                                  AppDimensions.spacingSmall),
                              child: ImageCard(
                                  imageBytes: widget.additionalImages[index],
                                  onImageRemoved: () {
                                    widget.onImageRemoved(index, false);
                                  }),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard(
      {super.key,
      required this.onImageRemoved,
      this.imageUrl,
      this.imageBytes});

  final Function onImageRemoved;
  final String? imageUrl;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && imageBytes == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        imageUrl != null
            ? Image.network(
                imageUrl!,
              )
            : Image.memory(imageBytes!),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => onImageRemoved(),
            child: Container(
              // circle around the close icon
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.backgroundColor.withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingExtraSmall),
                child: Icon(
                  Icons.close,
                  color: CustomColors.errorTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
